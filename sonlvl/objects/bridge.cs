using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace GameTapObjectDefinitions.Common
{
	class Bridge : ObjectDefinition
	{
		private Sprite img;

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("sprites/bridge_art.bin", CompressionType.Uncompressed);
			img = ObjectHelper.MapASMToBmp(artfile, "sprites/bridge_sprites.asm", 0, 2);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 7, 8, 9, 10, 11, 12, 13, 14, 15 }); }
		}

		public override string Name
		{
			get { return "Bridge"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override byte DefaultSubtype { get { return 8; } }

		public override string SubtypeName(byte subtype)
		{
			return ((subtype & 0xF) + 1) + " logs";
		}

		public override Sprite Image
		{
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return img;
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			int st = -((((obj.SubType & 0xF) + 1) * img.Width) / 2);
			List<Sprite> sprs = new List<Sprite>();
			for (int i = 0; i < ((obj.SubType & 0xF) + 1); i++)
			{
				Sprite tmp = new Sprite(img);
				tmp.Offset(st + (i * img.Width), 0);
				sprs.Add(tmp);
			}
			return new Sprite(sprs.ToArray());
		}
	}
}
