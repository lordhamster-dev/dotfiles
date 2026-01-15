// Coding Comfort Shader - 专为长时间编程设计的舒适着色器
// 特性: 柔和光晕、暖色调、轻微模糊、减少眼睛疲劳

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    // 基础参数
    float glowIntensity = 0.12;      // 光晕强度
    float warmthFactor = 0.03;       // 暖色调因子
    float contrastBoost = 0.05;      // 对比度提升
    float eyeStrain = 0.02;          // 眼睛疲劳减少因子

    // 获取原始颜色
    vec4 originalColor = texture(iChannel0, uv);

    // 应用轻微模糊以减少锯齿
    vec2 texelSize = 1.0 / iResolution.xy;
    vec4 blurColor = vec4(0.0);
    float totalWeight = 0.0;

    // 3x3 高斯模糊
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            float weight = 1.0 / (1.0 + float(x*x + y*y));
            vec2 offset = vec2(float(x), float(y)) * texelSize;
            blurColor += texture(iChannel0, uv + offset) * weight;
            totalWeight += weight;
        }
    }
    blurColor /= totalWeight;

    // 混合原始颜色和模糊颜色
    vec4 mixedColor = mix(originalColor, blurColor, 0.15);

    // 应用轻微的光晕效果
    vec4 glowColor = vec4(0.0);
    totalWeight = 0.0;

    for(int i = 0; i < 6; i++) {
        float angle = float(i) * 3.14159 * 2.0 / 6.0;
        vec2 offset = vec2(cos(angle), sin(angle)) * texelSize * 2.0;
        float weight = 1.0 / (float(i) + 1.0);
        glowColor += texture(iChannel0, uv + offset) * weight;
        totalWeight += weight;
    }
    glowColor /= totalWeight;

    // 只对亮区应用光晕
    float luminance = 0.299 * mixedColor.r + 0.587 * mixedColor.g + 0.114 * mixedColor.b;
    float glowMask = smoothstep(0.5, 0.9, luminance);
    mixedColor = mix(mixedColor, glowColor, glowMask * glowIntensity);

    // 应用暖色调 - 增加红色通道，减少蓝色通道
    mixedColor.r = mixedColor.r * (1.0 + warmthFactor);
    mixedColor.b = mixedColor.b * (1.0 - warmthFactor);

    // 提高对比度
    vec3 contrastColor = (mixedColor.rgb - 0.5) * (1.0 + contrastBoost) + 0.5;

    // 减少蓝光 - 对于眼睛疲劳
    contrastColor.b = contrastColor.b * (1.0 - eyeStrain);

    // 确保颜色在有效范围内
    contrastColor = clamp(contrastColor, 0.0, 1.0);

    // 输出最终颜色
    fragColor = vec4(contrastColor, mixedColor.a);
}
