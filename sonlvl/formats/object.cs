using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace SonicRetro.SonLVL.API.GameTap
{
	public class Object : ObjectLayoutFormat
	{
		static int ChunkSize = 256;
		
		public override Type ObjectType { get { return typeof(GameTapObjectEntry); } }
		
		public override List<ObjectEntry> ReadLayout(byte[] rawdata, out bool terminator)
		{
			List<ObjectEntry> obj_list = new List<ObjectEntry>();
			terminator = false;

			int chunk_count = ByteConverter.ToUInt16(rawdata, 0);
			int row_count = ByteConverter.ToUInt16(rawdata, 2);

			for (int row_index = 0; row_index < row_count; row_index++)
			{
				int row_addr = ByteConverter.ToUInt16(rawdata, (row_index * 2) + 4);
				if (row_addr != 0xFFFF)
				{
					for (int chunk_index = 0; chunk_index < chunk_count; chunk_index++)
					{
						int obj_addr = ByteConverter.ToUInt16(rawdata, row_addr + (chunk_index * 2));
						if (obj_addr != 0xFFFF)
						{
							int obj_count = ByteConverter.ToUInt16(rawdata, obj_addr);
							obj_addr += 2;
							for (int i = 0; i < obj_count; i++)
							{
								obj_list.Add(new GameTapObjectEntry(rawdata, obj_addr));
								obj_addr += GameTapObjectEntry.Size;
							}
						}
					}
				}
			}

			return obj_list;
		}
		
		public override byte[] WriteLayout(List<ObjectEntry> objects, bool terminator)
		{
			if (objects.Count == 0) return new byte[4];

			List<byte> tmp = new List<byte>();
			List<List<List<byte>>> obj_list = new List<List<List<byte>>>();

			int max_x = 0;
			int max_y = 0;
			foreach (ObjectEntry obj in objects)
			{
				if (obj.X > max_x) max_x = obj.X;
				if (obj.Y > max_y) max_y = obj.Y;
			}
			int row_count = (max_y / ChunkSize) + 1;
			int chunk_count = (max_x / ChunkSize) + 1;

			for (int row_index = 0; row_index < row_count; row_index++)
			{
				obj_list.Add(new List<List<byte>>());
				for (int chunk_index = 0; chunk_index < chunk_count; chunk_index++)
					obj_list[row_index].Add(new List<byte>());
			}

			int state_id = 0;
			foreach (ObjectEntry obj in objects)
			{
				int row_index = obj.Y / ChunkSize;
				int chunk_index = obj.X / ChunkSize;
					
				byte[] obj_data = obj.GetBytes();
				obj_data[0] = (byte)(state_id >> 8);
				obj_data[1] = (byte)(state_id++);
					
				obj_list[row_index][chunk_index].AddRange(obj_data);
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
					if (obj_list[row_index][chunk_index].Count > 0)
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
					int obj_addr = tmp.Count;

					int obj_count = obj_list[row_index][chunk_index].Count / GameTapObjectEntry.Size;
					if (obj_count > 0)
					{
						tmp.AddRange(ByteConverter.GetBytes((ushort)(obj_count)));
						tmp.AddRange(obj_list[row_index][chunk_index]);
						tmp[chunk_addr] = (byte)(obj_addr >> 8);
						tmp[chunk_addr + 1] = (byte)(obj_addr);
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
	}
	
	[DefaultProperty("ID")]
	[Serializable]
	public class GameTapObjectEntry : RememberStateObjectEntry
	{
		[Browsable(false)]
		public byte SubType2 { get; set; }

		[DisplayName("SubType2")]
		public string _SubType2
		{
			get { return SubType2.ToString("X2"); }
			set { SubType2 = byte.Parse(value, System.Globalization.NumberStyles.HexNumber); }
		}

		public static int Size { get { return 10; } }

		public GameTapObjectEntry() { pos = new Position(this); isLoaded = true; }

		public GameTapObjectEntry(byte[] file, int address)
		{
			byte[] bytes = new byte[Size];
			Array.Copy(file, address, bytes, 0, Size);
			FromBytes(bytes);
			pos = new Position(this);
			isLoaded = true;
		}

		public override byte[] GetBytes()
		{
			List<byte> ret = new List<byte>();
			ret.Add(0);
			ret.Add(0);
			ret.Add(ID);
			byte b = 0;
			if (XFlip) b |= 1;
			if (YFlip) b |= 2;
			ret.Add(b);
			ret.AddRange(ByteConverter.GetBytes(X));
			ret.AddRange(ByteConverter.GetBytes(Y));
			ret.Add(SubType);
			ret.Add(SubType2);
			return ret.ToArray();
		}
		
		public override void FromBytes(byte[] bytes)
		{
			ID = bytes[2];
			XFlip = (bytes[3] & 1) == 1;
			YFlip = (bytes[3] & 2) == 2;
			X = ByteConverter.ToUInt16(bytes, 4);
			Y = ByteConverter.ToUInt16(bytes, 6);
			SubType = bytes[8];
			SubType2 = bytes[9];
			RememberState = true;
		}
	}
}