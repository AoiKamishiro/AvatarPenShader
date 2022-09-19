// MIT
// 2022/09/20 by AoiKamishiro @aoi3192

Shader "Hidden/U-Stella/UnlitTwoSided"
{
    Properties
    {
        _MainTex ("Front Texture", 2D) = "white" {}
        _BackTex ("Back Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
            sampler2D _BackTex;
            float4 _MainTex_ST;
            float4 _BackTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            bool isFacing(fixed facing)
            {
                  return facing > 0;
            }

            fixed4 frag (v2f i, fixed facing: VFACE) : SV_Target
            {
                float2 uv = isFacing(facing) ? i.uv : float2(i.uv.x * -1, i.uv.y);
                fixed4 col = isFacing(facing) ? tex2D(_MainTex, uv) : tex2D(_BackTex, uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
