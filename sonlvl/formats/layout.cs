namespace SonicRetro.SonLVL.API.GameTap
{
	public class Layout : LayoutFormatSeparate
	{
		private void ReadLayoutInternal(byte[] rawdata, ref ushort[,] layout)
		{
			int w = ByteConverter.ToUInt16(rawdata, 0);
			int h = ByteConverter.ToUInt16(rawdata, 2);
			layout = new ushort[w, h];

			int c = 4;
			for (int lr = 0; lr < h; lr++)
			{
				int offset = ByteConverter.ToUInt16(rawdata, c) + 4;
				for (int lc = 0; lc < w; lc++)
				{
					layout[lc, lr] = ByteConverter.ToUInt16(rawdata, offset);
					offset += 2;
				}
				c += 2;
			}
		}

		public override void ReadFG(byte[] rawdata, LayoutData layout)
		{
			ReadLayoutInternal(rawdata, ref layout.FGLayout);
		}

		public override void ReadBG(byte[] rawdata, LayoutData layout)
		{
			ReadLayoutInternal(rawdata, ref layout.BGLayout);
		}

		private void WriteLayoutInternal(ushort[,] layout, out byte[] rawdata)
		{
			int w = layout.GetLength(0);
			int h = layout.GetLength(1);
			rawdata = new byte[(w * h * 2) + (h * 2) + 4];

			rawdata[0] = (byte)(w >> 8);
			rawdata[1] = (byte)(w & 0xFF);
			rawdata[2] = (byte)(h >> 8);
			rawdata[3] = (byte)(h & 0xFF);

			int c = 4;
			int row = h * 2;
			for (int lr = 0; lr < h; lr++)
			{
				rawdata[c++] = (byte)(row >> 8);
				rawdata[c++] = (byte)(row & 0xFF);
				row += w * 2;
			}
			for (int lr = 0; lr < h; lr++)
			{
				for (int lc = 0; lc < w; lc++)
				{
					rawdata[c++] = (byte)(layout[lc, lr] >> 8);
					rawdata[c++] = (byte)(layout[lc, lr] & 0xFF);
				}
			}
		}
		
		public override void WriteFG(LayoutData layout, out byte[] rawdata)
		{
			WriteLayoutInternal(layout.FGLayout, out rawdata);
		}

		public override void WriteBG(LayoutData layout, out byte[] rawdata)
		{
			WriteLayoutInternal(layout.BGLayout, out rawdata);
		}

		public override System.Drawing.Size MaxSize { get { return new System.Drawing.Size(1024, 1024); } }
	
		public override bool IsResizable { get { return true; } }
	}
}
