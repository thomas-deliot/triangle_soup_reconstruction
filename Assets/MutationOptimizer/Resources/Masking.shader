Shader "Custom/Masking"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha (A)", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				col.a = tex2D(_AlphaTex, i.uv).r;
				col.rgb *= col.a;
				return col;
			}
			ENDCG
		}
	}
}