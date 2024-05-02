shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,depth_test_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_emission : source_color, hint_default_black,filter_linear_mipmap,repeat_enable;
uniform vec4 emission : source_color;
uniform sampler2D noise_tex;
uniform sampler2D disappear_noise_tex;
uniform float ratio = 0.1;
uniform float threshold = 0.5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float radius : hint_range( 0.0, 1.0 ) = 0.5;
uniform vec4 color : source_color;
uniform float scale = 32.0;
uniform float power = 9.0;
uniform bool voronoi_active = false;
uniform float noise_size = 1.6;
uniform float noise_alternative_size = 1.6;

vec2 random( vec2 pos )
{ 
	return fract(
		sin(
			vec2(
				dot(pos, vec2(12.9898,78.233))
			,	dot(pos, vec2(-148.998,-65.233))
			)
		) * 43758.5453
	);
}

vec2 voronoi( vec2 uv )
{
	vec2 v = uv * scale;
	vec2 v_floor = floor( v );
	vec2 v_fract = fract( v );

	vec2 min_p = vec2( 0.0, 0.0 );
	float min_dist = 2.0;

	for( int y = -1; y <= 1; y ++ ) {
		for( int x = -1; x <= 1; x ++ ) {
			vec2 n = vec2( float( x ), float( y ) );
			vec2 p = random( v_floor + n );
			vec2 diff = p + n;
			float d = distance( v_fract, diff );

			min_p = mix( min_p, ( v + diff - v_fract ) / scale, float( d < min_dist ) );
			min_dist = min( min_dist, d );
		}
	}

	return min_p;
}

void fragment() {
    vec2 base_uv = UV;

    vec4 noise = texture(noise_tex, vec2(base_uv.x, base_uv.y + TIME * ratio) * noise_size);
    vec4 noise_static = texture(disappear_noise_tex, vec2(base_uv.x, base_uv.y) * noise_alternative_size);
    
    if (noise.r > threshold) {
        discard;
    }

    vec4 albedo_tex = texture(texture_albedo, base_uv);
    ALBEDO = albedo.rgb * albedo_tex.rgb;
    
    vec3 emission_tex = texture(texture_emission,base_uv).rgb;
    EMISSION = (emission.rgb);
	
	vec2 conv_uv = voronoi( UV );
	float f = clamp( 1.0 - abs( distance( conv_uv, vec2( 0.5, 0.5 ) ) - radius ) * power, 0.0, 1.0 );

	ALBEDO = mix( textureLod( SCREEN_TEXTURE, conv_uv, 0.0 ).rgb, color.rgb, color.a );
	
	if(voronoi_active) {
		ALPHA = max(noise_static.r - radius, 0.0);
	} else {
    	ALPHA *= albedo.a * albedo_tex.a;
	}	
}