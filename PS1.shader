Shader "Unlit/PS1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[PowerSlider(2.0)]_Precision ("Precision", Range(0, 1000)) = 1
		//_Mosaic ("Mosaic", Range(0,1000)) = 1
		[PowerSlider(2.0)]_UVprecision ("UVprecision", Range(0,1000)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		//ZTest Always
		//Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Precision;
			float _Mosaic;
			float _UVprecision;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				o.vertex = o.vertex - frac(o.vertex * _Precision) * 1 / _Precision;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//i.uv = floor(i.uv * _Mosaic) / _Mosaic;
				i.uv = i.uv - frac(i.uv * _UVprecision) / _UVprecision;
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
