using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace SonicRetro.SonLVL.API.GameTap
{
	public class Ring : RingLayoutFormat
	{
		static int ChunkSize = 256;
		
		Sprite spr;

		public Ring()
		{
			spr = ObjectHelper.UnknownObject;
		}
		
		public override List<RingEntry> ReadLayout(byte[] rawdata, out bool startterm, out bool endterm)
		{
			List<RingEntry> ring_list = new List<RingEntry>();
			startterm = false;
			endterm = false;

			int chunk_count = ByteConverter.ToUInt16(rawdata, 0);
			int row_count = ByteConverter.ToUInt16(rawdata, 2);

			for (int row_index = 0; row_index < row_count; row_index++)
			{
				int row_addr = ByteConverter.ToUInt16(rawdata, (row_index * 2) + 4);
				if (row_addr != 0xFFFF)
				{
					for (int chunk_index = 0; chunk_index < chunk_count; chunk_index++)
					{
						int ring_addr = ByteConverter.ToUInt16(rawdata, row_addr + (chunk_index * 2));
						if (ring_addr != 0xFFFF)
						{
							int ring_count = ByteConverter.ToUInt16(rawdata, ring_addr);
							ring_addr += 2;
							for (int i = 0; i < ring_count; i++)
							{
								ring_list.Add(new GameTapRingEntry(rawdata, ring_addr));
								ring_addr += GameTapRingEntry.Size;
							}
						}
					}
				}
			}

			return ring_list;
		}
		
		public override byte[] WriteLayout(List<RingEntry> rings, bool startterm, bool endterm)
		{
			if (rings.Count == 0) return new byte[4];
			rings.Sort();

			List<byte> tmp = new List<byte>();
			List<List<List<byte>>> ring_list = new List<List<List<byte>>>();

			int max_x = 0;
			int max_y = 0;
			foreach (RingEntry ring in rings)
			{
				ushort x = (ushort)(ring.X - 16);
				ushort y = (ushort)(ring.Y - 16);
				
				if (x > max_x) max_x = x;
				if (y > max_y) max_y = y;
			}
			int row_count = (max_y / ChunkSize) + 1;
			int chunk_count = (max_x / ChunkSize) + 1;

			for (int row_index = 0; row_index < row_count; row_index++)
			{
				ring_list.Add(new List<List<byte>>());
				for (int chunk_index = 0; chunk_index < chunk_count; chunk_index++)
					ring_list[row_index].Add(new List<byte>());
			}

			int state_id = 0;
			foreach (RingEntry ring in rings)
			{
				ushort x = (ushort)(ring.X - 16);
				ushort y = (ushort)(ring.Y - 16);
				
				int row_index = y / ChunkSize;
				int chunk_index = x / ChunkSize;
				
				byte[] ring_data = ring.GetBytes();
				ring_data[0] = (byte)(state_id >> 8);
				ring_data[1] = (byte)(state_id++);
				
				ring_list[row_index][chunk_index].AddRange(ring_data);
			}
			
			tmp.AddRange(ByteConverter.GetBytes((ushort)(chunk_count)));
			tmp.AddRange(ByteConverter.GetBytes((ushort)(row_count)));

			int row_addr = (row_count * 2) + 4;
			List<int> used_rows = new List<int>();
			for (int row_index = 0; row_index < row_count; row_index++)
			{
				bool used = false;
				for (int chunk_index = 0; chunk_index < chunk_count; chunk_index++)
				{
					if (ring_list[row_index][chunk_index].Count > 0)
					{
						used = true;
						break;
					}
				}

				if (used)
				{
					tmp.AddRange(ByteConverter.GetBytes((ushort)(row_addr)));
					row_addr += chunk_count * 2;
					used_rows.Add(row_index);
				}
				else
				{
					tmp.AddRange(ByteConverter.GetBytes((ushort)0xFFFF));
				}
			}
			tmp.AddRange(new byte[used_rows.Count * chunk_count * 2]);
			
			for (int used_row_index = 0; used_row_index < used_rows.Count; used_row_index++)
			{
				int row_index = used_rows[used_row_index];
				for (int chunk_index = 0; chunk_index < chunk_count; chunk_index++)
				{
					int chunk_addr = (row_count * 2) + 4 + (used_row_index * chunk_count * 2) + (chunk_index * 2);
					int ring_addr = tmp.Count;

					int ring_count = ring_list[row_index][chunk_index].Count / GameTapRingEntry.Size;
					if (ring_count > 0)
					{
						tmp.AddRange(ByteConverter.GetBytes((ushort)(ring_count)));
						tmp.AddRange(ring_list[row_index][chunk_index]);
						tmp[chunk_addr] = (byte)(ring_addr >> 8);
						tmp[chunk_addr + 1] = (byte)(ring_addr);
					}
					else
					{
						tmp[chunk_addr] = 0xFF;
						tmp[chunk_addr + 1] = 0xFF;
					}
				}
			}

			return tmp.ToArray();
		}

		public override void Init(ObjectData data)
		{
			try
			{
				if (data.Art != null)
				{
					MultiFileIndexer<byte> art = new MultiFileIndexer<byte>();
					foreach (FileInfo file in data.Art)
						art.AddFile(new List<byte>(ObjectHelper.OpenArtFile(file.Filename, data.ArtCompression)), file.Offset);
					byte[] artfile = art.ToArray();
					if (data.MapFile != null)
					{
						if (data.DPLCFile != null)
							spr = ObjectHelper.MapDPLCToBmp(artfile, LevelData.ReadFile(data.MapFile, data.MapCompression), data.MapVersion, LevelData.ReadFile(data.DPLCFile, data.DPLCCompression), data.DPLCVersion, data.Frame, data.Palette, data.Priority);
						else
							spr = ObjectHelper.MapToBmp(artfile, LevelData.ReadFile(data.MapFile, data.MapCompression), data.Frame, data.Palette, data.Priority, data.MapVersion);
					}
					else if (data.MapFileAsm != null)
					{
						if (data.MapAsmLabel != null)
						{
							if (data.DPLCFileAsm != null)
								spr = ObjectHelper.MapASMDPLCToBmp(artfile, data.MapFileAsm, data.MapAsmLabel, data.MapVersion, data.DPLCFileAsm, data.DPLCAsmLabel, data.DPLCVersion, data.Palette, data.Priority);
							else
								spr = ObjectHelper.MapASMToBmp(artfile, data.MapFileAsm, data.MapAsmLabel, data.Palette, data.Priority, data.MapVersion);
						}
						else
						{
							if (data.DPLCFileAsm != null)
								spr = ObjectHelper.MapASMDPLCToBmp(artfile, data.MapFileAsm, data.MapVersion, data.DPLCFileAsm, data.DPLCVersion, data.Frame, data.Palette, data.Priority);
							else
								spr = ObjectHelper.MapASMToBmp(artfile, data.MapFileAsm, data.Frame, data.Palette, data.Priority, data.MapVersion);
						}
					}
					else
						spr = ObjectHelper.UnknownObject;
					if (data.Offset != Size.Empty)
						spr.Offset(data.Offset);
				}
				else if (data.Image != null)
				{
					BitmapBits img = new BitmapBits(data.Image);
					spr = new Sprite(img, new Point(data.Offset));
				}
				else if (data.Sprite > -1)
					spr = ObjectHelper.GetSprite(data.Sprite);
				else
					spr = ObjectHelper.UnknownObject;
			}
			catch (Exception ex)
			{
				LevelData.Log("Error loading GameTap ring definition:", ex.ToString());
				spr = ObjectHelper.UnknownObject;
			}
		}

		public override Sprite Image { get { return spr; } }

		public override Rectangle GetBounds(RingEntry rng)
		{
			return new Rectangle(rng.X + spr.X, rng.Y + spr.Y, spr.Width, spr.Height);
		}

		public override Sprite GetSprite(RingEntry rng)
		{
			return spr;
		}

		public override Entry CreateRing()
		{
			return new GameTapRingEntry();
		}

		public override string Name
		{
			get { return "Ring"; }
		}

		public override int CountRings(IEnumerable<RingEntry> rings)
		{
			return rings.OfType<GameTapRingEntry>().Count();
		}
	}

	[Serializable]
	public class GameTapRingEntry : RingEntry
	{
		public static int Size { get { return 6; } }

		public GameTapRingEntry() { pos = new Position(this); }

		public GameTapRingEntry(byte[] file, int address)
		{
			byte[] bytes = new byte[Size];
			Array.Copy(file, address, bytes, 0, Size);
			FromBytes(bytes);
			pos = new Position(this);
		}

		public override byte[] GetBytes()
		{
			List<byte> ret = new List<byte>();
			ret.Add(0);
			ret.Add(0);
			ret.AddRange(ByteConverter.GetBytes(X));
			ret.AddRange(ByteConverter.GetBytes(Y));
			return ret.ToArray();
		}

		public override void FromBytes(byte[] bytes)
		{
			X = ByteConverter.ToUInt16(bytes, 2);
			Y = ByteConverter.ToUInt16(bytes, 4);
		}

		public override void UpdateSprite()
		{
			_sprite = ((RingLayoutFormat)LevelData.RingFormat).GetSprite(this);
			_bounds = ((RingLayoutFormat)LevelData.RingFormat).GetBounds(this);
			if (_bounds.IsEmpty)
			{
				_bounds = _sprite.Bounds;
				_bounds.Offset(X, Y);
			}
		}
	}
}