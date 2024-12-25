Shader "Custom/BuoyancyShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _BobbingHeight ("Bobbing Height", Range(0, 10)) = 1.0
        _BobbingSpeed ("Bobbing Speed", Range(0, 10)) = 1.0
        _TimeScale ("Time Scale", Range(0, 10)) = 1.0
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float4 color : COLOR;
            };

            // Properties
            float _BobbingHeight;
            float _BobbingSpeed;
            float _TimeScale;

            // Vertex shader
            v2f vert(appdata v)
            {
                v2f o;

                // Get the time in seconds
                float time = _Time.y * _TimeScale;

                // Calculate the bobbing effect using a sine wave
                float bobbing = sin(time * _BobbingSpeed + v.vertex.x * 0.1) * _BobbingHeight * 0.001;

                // Apply the bobbing effect to the y-position of the object
                v.vertex.z += bobbing;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                return o;
            }

            // Fragment shader (we will just use the base texture for now)
            half4 frag(v2f i) : SV_Target
            {
                return half4(1, 1, 1, 1);  // Simple white color (you can apply texture here)
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
