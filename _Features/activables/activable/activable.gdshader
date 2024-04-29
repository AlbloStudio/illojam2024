shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,depth_test_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_emission : source_color, hint_default_black,filter_linear_mipmap,repeat_enable;
uniform vec4 emission : source_color;
uniform sampler2D noise_tex;
uniform float ratio = 0.1;
uniform float threshold = 0.5;

void fragment() {
    vec2 base_uv = UV;

    vec4 noise = texture(noise_tex, base_uv + TIME * ratio);
    
    if (noise.r > threshold) {
        discard;
    }

    vec4 albedo_tex = texture(texture_albedo, base_uv);
    ALBEDO = albedo.rgb * albedo_tex.rgb;
    
    vec3 emission_tex = texture(texture_emission,base_uv).rgb;
    EMISSION = (emission.rgb);
    ALPHA *= albedo.a * albedo_tex.a;
}