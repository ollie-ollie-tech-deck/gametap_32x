-- Bitstream
local bit_pos = 0
local cur_byte = 0
local line_pos = 0
local cur_type = ""

-- Get number of bits a number has
local function get_bits(val)
	return math.floor(math.log(val) / math.log(2)) + 1
end

-- Apply mask to byte
local function mask_byte(val)
	return string.char(math.floor(val) % 256)
end

-- Write a value to the file in Chaotix format
local function write_chaotix_value(file, val, type)
	if cur_type ~= type then
		if line_pos > 0 then
			file:write("\n")
		end
		line_pos = 0
		cur_type = type
	end
	if line_pos % 16 == 0 then
		file:write("\t" .. type .. "\t")
	else
		file:write(", ")
	end
	file:write(val)
	if line_pos % 16 == 15 then
		file:write("\n")
	end
	line_pos = line_pos + 1
end

-- Write a byte to the file
local function write_byte(file, val, chaotix)
	if chaotix then
		write_chaotix_value(file, val, "dc.b")
	else
		file:write(mask_byte(val))
	end
end

-- Write a word to the file
local function write_word(file, val, chaotix)
	if chaotix then
		write_chaotix_value(file, val, "dc.w")
	else
		file:write(mask_byte(val / 256))
		file:write(mask_byte(val))
	end
end

-- Write a longword to the file
local function write_long(file, val, chaotix)
	if chaotix then
		write_chaotix_value(file, val, "dc.l")
	else
		write_word(file, val / 65536)
		write_word(file, val)
	end
end

-- Write byte of bitstream to file
local function write_bitstream_byte(file, chaotix)
	write_byte(file, cur_byte, chaotix)
	bit_pos = 0
	cur_byte = 0
end

-- Write bits to file
local function write_bits(file, val, bits, chaotix)
	for i = bits - 1, 0, -1 do
		cur_byte = (cur_byte * 2) + (math.floor(val / (2 ^ i)) % 2)
		bit_pos = bit_pos + 1
		if bit_pos == 8 then
			write_bitstream_byte(file, chaotix)
		end
	end
end

-- Flush bits to file
local function flush_bits(file, chaotix)
	if bit_pos > 0 then
		while bit_pos < 8 do
			cur_byte = (cur_byte * 2)
			bit_pos = bit_pos + 1
		end
		write_bitstream_byte(file, chaotix)
	end
end

-- Read byte from file
local function read_byte(file)
	return file:read(1):byte()
end

-- Read signed byte from file
local function read_signed_byte(file)
	local val = read_byte(file)
	if val >= 128 then
		val = val - 256
	end
	return val
end

-- Read word from file
local function read_word(file)
	return (read_byte(file) * 256) + read_byte(file)
end

-- Read signed word from file
local function read_signed_word(file)
	local val = (read_byte(file) * 256) + read_byte(file)
	if val >= 32768 then
		val = val - 65536
	end
	return val
end

-- Read longword from file
local function read_long(file)
	return (read_word(file) * 65536) + read_word(file)
end

-- Read bits from file
local function read_bits(file, bits)
	local val = 0
	for i = 1, bits do
		if bit_pos < 0 then
			bit_pos = 7
			cur_byte = read_byte(file)
		end
		val = (val * 2) + (math.floor(cur_byte / (2 ^ bit_pos)) % 2)
		bit_pos = bit_pos - 1
	end
	return val
end

-- Open sprites
local function open_sprites(dlg)
	-- Open sprite file
	local file = io.open(dlg.data.sprites_open_file, "rb")

	-- Get number of frames
	local count = read_long(file)

	-- Load sprite data
	local canvas = {}
	local max_bound_l = 0
	local max_bound_r = 0
	local max_bound_t = 0
	local max_bound_b = 0
	local index_addr = 4

	for i = 1, count do
		-- Prepare bitstream
		bit_pos = -1

		-- Prepare canvas
		canvas[i] = {}
		for y = -127, 128 do
			canvas[i][y] = {}
			for x = -127, 128 do
				canvas[i][y][x] = 0
			end
		end

		-- Seek to sprite frame data
		local seek_pos = read_long(file)
		if seek_pos ~= 4294967295 then
			file:seek("set", seek_pos)

			-- Get boundaries and compression information about sprite frame
			local bound_l = read_signed_word(file)
			local bound_r = 0
			local bound_t = 0
			local bound_b = 0
			local compressed = read_byte(file) == 66
			local x_bits = 0
			local y_bits = 0
			local pixel_base = 0
			local pixel_bits = 0

			if compressed then
				bound_l = read_signed_byte(file)
				x_bits = read_byte(file)
				bound_t = read_signed_byte(file)
				y_bits = read_byte(file)
				pixel_base = read_byte(file)
				pixel_bits = read_byte(file)
				bound_r = bound_l +  read_bits(file, x_bits)
				bound_b = bound_t +  read_bits(file, y_bits)
			else
				file:seek("cur", -1)
				bound_r = read_signed_word(file)
				bound_t = math.floor(read_signed_word(file) / 256)
				bound_b = math.floor(read_signed_word(file) / 256)
			end

			if bound_l < max_bound_l then
				max_bound_l = bound_l
			end
			if bound_r > max_bound_r then
				max_bound_r = bound_r
			end
			if bound_t < max_bound_t then
				max_bound_t = bound_t
			end
			if bound_b > max_bound_b then
				max_bound_b = bound_b
			end

			-- Load sprite frame data
			while true do
				-- Get row left and right positions
				local left = 0
				local right = 0

				if compressed then
					left = read_bits(file, x_bits) + bound_l
					right = read_bits(file, x_bits) + bound_l
				else
					left = read_signed_byte(file)
					right = read_signed_byte(file)
				end

				-- Check if at the end of the sprite frame data
				if left == right then
					break
				end

				-- Get row Y position
				local y = 0
				if compressed then
					y = read_bits(file, y_bits) + bound_t
				else
					y = math.floor(read_signed_word(file) / 256)
				end

				-- Load row data
				for x = left + 1, right do
					local px = 0
					if compressed then
						px = read_bits(file, pixel_bits) + pixel_base
					else
						px = read_byte(file)
					end
					canvas[i][y + 1][x] = px
				end
			end
		end

		-- Next frame
		index_addr = index_addr + 4
		file:seek("set", index_addr)
	end

	-- Close file
	file:close()
	
	-- Upload pixels
	max_bound_l = max_bound_l - (max_bound_l % 2)
	max_bound_r = max_bound_r + (max_bound_r % 2)
	max_bound_t = max_bound_t - (max_bound_t % 2)
	max_bound_b = max_bound_b + (max_bound_b % 2)

	if (-max_bound_l < max_bound_r) then
		max_bound_l = -max_bound_r
	elseif (max_bound_r < -max_bound_l) then
		max_bound_r = -max_bound_l
	end
	if (-max_bound_t < max_bound_b) then
		max_bound_t = -max_bound_b
	elseif (max_bound_b < -max_bound_t) then
		max_bound_b = -max_bound_t
	end

	local sprite_width = max_bound_r - max_bound_l
	local sprite_height = max_bound_b - max_bound_t

	local sprite = Sprite(sprite_width, sprite_height, ColorMode.INDEXED)

	for i = 1, count do
		if i > 1 then
			sprite:newEmptyFrame()
		end
		local cel = sprite:newCel(sprite.layers[1], i)

		for y = -128, 127 do
			for x = -128, 127 do
				local px = x + (sprite_width / 2)
				local py = y + (sprite_height / 2)
				local c = canvas[i][y + 1][x + 1]

				if px >= 0 and px < sprite_width and py >= 0 and py < sprite_height then
					cel.image:drawPixel(px, py, c)
				end
			end
		end
	end
end

-- Process layer
local function process_layer(layer, sprite, canvas)
	if layer.isGroup then
		for i, sub_layer in ipairs(layer.layers) do
			process_layer(sub_layer, sprite, canvas)
		end
	else
		for i, cel in ipairs(layer.cels) do
			for it in cel.image:pixels() do
				local pixel = it()
				if pixel > 0 and pixel < #sprite.palettes[1] then
					local x = cel.position.x + it.x
					local y = cel.position.y + it.y
					
					if x >= 0 and x < sprite.width and y >= 0 and y < sprite.height then
						canvas[cel.frameNumber][y + 1][x + 1] = pixel
					end
				end
			end
		end
	end
end

-- Save sprites
local function save_sprites(filename, compressed, chaotix)
	-- Check if a sprite is active
	local sprite = app.activeSprite
	if not sprite then return app.alert("No active sprite") end

	-- Get aligned sprite size
	local sprite_width = sprite.width + (sprite.width % 2)
	local sprite_height = sprite.height + (sprite.height % 2)
	local width_expand = math.floor((sprite.width % 4) / 2)

	-- Prepare bitstream
	bit_pos = 0
	cur_byte = 0

	-- Prepare canvas
	local canvas = {}
	for i = 1, #sprite.frames do
		canvas[i] = {}
		for y = 1, sprite_height do
			canvas[i][y] = {}
			for x = 0, sprite_width + 1 do
				canvas[i][y][x] = 0
			end
		end
	end

	-- Get pixels from sprite
	for i, layer in ipairs(sprite.layers) do
		process_layer(layer, sprite, canvas)
	end

	-- Open sprite file
	local mode = "wb"
	if chaotix then
		mode = "w"
	end
	local file = io.open(filename, mode)

	-- Prepare sprite frame index
	local frame_addrs = {}
	if not chaotix then
		-- Write blank sprite frame index
		write_long(file, #sprite.frames, false)
		for i = 1, #sprite.frames do
			write_long(file, 0, false)
			frame_addrs[i] = 0
		end
	else
		-- Write random label
		math.randomseed(os.time())
		file:write("ChaotixSprites_")
		local valid = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
		for i = 1, 16 do
			local char_pos = math.random(1, #valid)
			file:write(string.sub(valid, char_pos, char_pos))
		end
		file:write(":\n")

		-- Write sprite frame index
		for i = 1, #sprite.frames do
			file:write("\tdc.l\t" .. ".Frame" .. i .. "\n")
		end
	end

	-- Write sprite frames
	for i = 1, #sprite.frames do
		-- Get boundaries and compression information about sprite frame
		local used = false
		local bound_l = 65536
		local bound_r = -65536
		local bound_t = 65536
		local bound_b = -65536
		local pixel_base = 65536
		local max_pixel = 0

		for y = 1, sprite.height do
			for x = 1, sprite.width do
				local px = (x - 1) - math.floor(sprite_width / 2)
				local py = (y - 1) - math.floor(sprite_height / 2)

				if canvas[i][y][x] ~= 0 then
					used = true
					if px < bound_l then
						bound_l = px
					end
					if (px + 1) > bound_r then
						bound_r = px + 1
					end
					if py < bound_t then
						bound_t = py
					end
					if (py + 1) > bound_b then
						bound_b = py + 1
					end
				end

				if canvas[i][y][x] < pixel_base then
					pixel_base = canvas[i][y][x]
				end
				if canvas[i][y][x] > max_pixel then
					max_pixel = canvas[i][y][x]
				end
			end
		end

		bound_l = bound_l - width_expand
		bound_r = bound_r + width_expand
		bound_l = bound_l - (bound_l % 2)
		bound_r = bound_r + (bound_r % 2)

		if not used then
			bound_l = 0
			bound_r = 0
			bound_t = 0
			bound_b = 0
		end
		
		local x_bits = get_bits(bound_r - bound_l)
		local y_bits = get_bits(bound_b - bound_t)
		local pixel_bits = get_bits(max_pixel - pixel_base)

		if (max_pixel - pixel_base) == 0 then
			pixel_bits = 1
			if pixel_base > 0 then
				pixel_base = pixel_base - 1
			end
		end
		
		-- Get row positions length of sprite frame data
		local frame_len = 10
		local frame_rows = {}
		local row_idx = 1
		
		for y = 1, sprite.height do
			used = false

			-- Get left
			local left = 0
			for x = 1, sprite.width do
				if canvas[i][y][x] ~= 0 then
					left = x - 1
					used = true
					break
				end
			end
			left = left - (left % 2)

			-- Get right
			local right = 0
			for x = 1, sprite.width do
				if canvas[i][y][(sprite.width + 1) - x] ~= 0 then
					right = (sprite.width + 1) - x
					used = true
					break
				end
			end
			right = right + (right % 2)
			
			-- Check if row is defined
			if used then
				frame_rows[row_idx] = {}
				frame_rows[row_idx][1] = left
				frame_rows[row_idx][2] = right
				frame_rows[row_idx][3] = y
				row_idx = row_idx + 1
				frame_len = frame_len + (right - left) + 4
			end
		end
		
		-- Prepare for writing
		bit_pos = 0
		cur_byte = 0
		if not chaotix then
			frame_addrs[i] = file:seek()
		end

		-- Write header
		if chaotix then
			file:write("\n.Frame" .. i .. ":\n")
		end
		if compressed then
			write_word(file, frame_len, chaotix)
			write_byte(file, 66, chaotix)
			write_byte(file, bound_l, chaotix)
			write_byte(file, x_bits, chaotix)
			write_byte(file, bound_t, chaotix)
			write_byte(file, y_bits, chaotix)
			write_byte(file, pixel_base, chaotix)
			write_byte(file, pixel_bits, chaotix)
			write_bits(file, bound_r - bound_l, x_bits, chaotix)
			write_bits(file, bound_b - bound_t, y_bits, chaotix)
		else
			write_word(file, bound_l, chaotix)
			write_word(file, bound_r, chaotix)
			write_byte(file, bound_t, chaotix)
			write_byte(file, 0, chaotix)
			write_byte(file, bound_b, chaotix)
			write_byte(file, 0, chaotix)
		end

		-- Write pixels
		for r = 1, #frame_rows do
			local left = frame_rows[r][1]
			local right = frame_rows[r][2]
			local y = frame_rows[r][3]

			-- Row position
			if compressed then
				write_bits(file, (left - math.floor(sprite_width / 2)) - width_expand - bound_l, x_bits, chaotix)
				write_bits(file, (right - math.floor(sprite_width / 2)) + width_expand - bound_l, x_bits, chaotix)
				write_bits(file, (y - math.floor(sprite_height / 2) - 1) - bound_t, y_bits, chaotix)
			else
				write_byte(file, left - math.floor(sprite_width / 2) - width_expand, chaotix)
				write_byte(file, right - math.floor(sprite_width / 2) + width_expand, chaotix)
				write_byte(file, y - math.floor(sprite_height / 2) - 1, chaotix)
				write_byte(file, 0, chaotix)
			end

			-- Write pixel data
			local r = 0
			for x = (left + 1) - width_expand, right + width_expand do
				local px = canvas[i][y][x]
				if compressed then
					px = px - pixel_base
					if px < 0 then
						px = 0
					end
					write_bits(file, px, pixel_bits, chaotix)
				else
					write_byte(file, px, chaotix)
				end
			end
		end
		
		-- Write terminator
		if compressed then
			write_bits(file, 0, x_bits, chaotix)
			write_bits(file, 0, x_bits, chaotix)
			flush_bits(file, chaotix)
		else
			write_byte(file, 0, chaotix)
			write_byte(file, 0, chaotix)
		end

		if not chaotix then
			while (file:seek() % 2) ~= 0 do
				write_byte(file, 0, false)
			end
		else
			if line_pos % 16 ~= 0 then
				file:write("\n")
			end
			file:write("\teven\n")
		end
		line_pos = 0
	end

	-- Write frame index
	if not chaotix then
		file:seek("set", 4)
		for i = 1, #sprite.frames do
			write_long(file, frame_addrs[i], false)
		end
	end

	-- Close file
	file:close()
end

-- Save uncompressed sprites
local function save_uncompressed_sprites(dlg)
	save_sprites(dlg.data.sprites_save_uncompressed_file, false, false)
end

-- Save compressed sprites
local function save_compressed_sprites(dlg)
	save_sprites(dlg.data.sprites_save_compressed_file, true, false)
end

-- Save uncompressed Chaotix sprites
local function save_uncompressed_chaotix_sprites(dlg)
	save_sprites(dlg.data.sprites_save_uncompressed_chaotix_file, false, true)
end

-- Save compressed Chaotix sprites
local function save_compressed_chaotix_sprites(dlg)
	save_sprites(dlg.data.sprites_save_compressed_chaotix_file, true, true)
end

-- Set palette color
local function set_palette_color(palette, color, i)
	local r = math.floor(((color % 32) * 255) / 31)
	local g = math.floor(((math.floor(color / 32) % 32) * 255) / 31)
	local b = math.floor(((math.floor(color / 1024) % 32) * 255) / 31)
	palette:setColor(i, Color{ r = r, g = g, b = b })
end

-- Open palette
local function open_palette(dlg)
	-- Check if a sprite is active
	local sprite = app.activeSprite
	if not sprite then return app.alert("No active sprite") end

	-- Open palette file
	local palette = sprite.palettes[1]
	local file = io.open(dlg.data.palette_open_file, "rb")

	-- Get color count
	local count = read_word(file)
	palette:resize(count + 1)

	-- Set colors
	local color = 0
	for i = 1, count do
		set_palette_color(palette, read_word(file), i)
	end

	-- Close file
	file:close()
end

-- Open Chaotix palette
local function open_chaotix_palette(dlg)
	-- Check if a sprite is active
	local sprite = app.activeSprite
	if not sprite then return app.alert("No active sprite") end

	-- Open palette file
	local palette = sprite.palettes[1]
	local file = io.open(dlg.data.palette_open_chaotix_file, "rb")
	local read = file:read(2 * 255)

	-- Set colors
	local i = 0
	local color = 0
	for c in (read or ''):gmatch'.' do
		local byte = c:byte()
		if i % 2 == 0 then
			color = byte * 256
		else
			local idx = math.floor(i / 2) + 1
			color = color + byte
			palette:resize(idx + 1)
			set_palette_color(palette, color, idx)
		end
		i = i + 1
	end

	-- Close file
	file:close()
end

-- Save palette file
local function save_palette_file(filename, chaotix)
	-- Check if a sprite is active
	local sprite = app.activeSprite
	if not sprite then return app.alert("No active sprite") end

	-- Open palette file
	local file = io.open(filename, "wb")

	-- Write color count
	local palette = sprite.palettes[1]
	if not chaotix then
		write_word(file, #palette - 1, false)
	end

	-- Write colors
	for i = 1, #palette - 1 do
		local color = palette:getColor(i)
		local r = math.floor(((color.red * 31) / 255) + 0.5)
		local g = math.floor(((color.green * 31) / 255) + 0.5)
		local b = math.floor(((color.blue * 31) / 255) + 0.5)
		
		local bgr = (b * 1024) + (g * 32) + r
		write_word(file, bgr, false)
	end

	-- Close file
	file:close()
end

-- Save palette
local function save_palette(dlg)
	save_palette_file(dlg.data.palette_save_file, false)
end

-- Save Chaotix palette
local function save_chaotix_palette(dlg)
	save_palette_file(dlg.data.palette_save_chaotix_file, true)
end

-- Open file dialog
local dlg = Dialog{
	title="GameTap 32X"
}
dlg:file{
	id = "sprites_open_file",
	label = "Open Sprites",
	open = true,
	save = false,
	filetypes = { "spr" },
	onchange = function()
		open_sprites(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "sprites_save_uncompressed_file",
	label = "Save Uncompressed Sprites",
	open = false,
	save = true,
	filetypes = { "spr" },
	onchange = function()
		save_uncompressed_sprites(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "sprites_save_compressed_file",
	label = "Save Compressed Sprites",
	open = false,
	save = true,
	filetypes = { "spr" },
	onchange = function()
		save_compressed_sprites(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "sprites_save_uncompressed_chaotix_file",
	label = "Save Uncompressed Chaotix Sprites",
	open = false,
	save = true,
	filetypes = { "asm" },
	onchange = function()
		save_uncompressed_chaotix_sprites(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "sprites_save_compressed_chaotix_file",
	label = "Save Compressed Chaotix Sprites",
	open = false,
	save = true,
	filetypes = { "asm" },
	onchange = function()
		save_compressed_chaotix_sprites(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "palette_open_file",
	label = "Open Palette",
	open = true,
	save = false,
	filetypes = { "pal" },
	onchange = function()
		open_palette(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "palette_save_file",
	label = "Save Palette",
	open = false,
	save = true,
	filetypes = { "pal" },
	onchange = function()
		save_palette(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "palette_open_chaotix_file",
	label = "Open Chaotix Palette",
	open = true,
	save = false,
	filetypes = { "pal" },
	onchange = function()
		open_chaotix_palette(dlg)
		dlg:close()
	end
}
dlg:file{
	id = "palette_save_chaotix_file",
	label = "Save Chaotix Palette",
	open = false,
	save = true,
	filetypes = { "pal" },
	onchange = function()
		save_chaotix_palette(dlg)
		dlg:close()
	end
}
dlg:show()