#ifdef GL_ES
precision mediump float;
#endif

uniform float X;
uniform float Y;
uniform float u_time;

float drawHall(vec2 st){
    return abs(st.y - st.x)*mix(0.3,0.7,sin(u_time)+1.0);
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);

    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < 5; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

float pattern( in vec2 p, out vec2 q, out vec2 r )
{
    q.x = fbm( p + vec2(0.0,0.0) );
    q.y = fbm( p + vec2(0.810,0.360));

    r.x = fbm( p + 2.0*q/mix(2.,5., u_time) + vec2(sin(0.4*u_time),1.616*sin(0.4*u_time)));
    r.y = fbm( p + 3.0*q-mix(0.,0.01, u_time) + vec2(0.640,cos(0.4*u_time)+1.5) );

    return fbm( p + 4.0*r );
}

void main() {
    vec2 resolution = vec2(X,Y);
    vec2 st = gl_FragCoord.xy/resolution.xy;
    float p1;
    float p2;
    vec3 color = vec3(.7*sin(u_time)+1.,-.6*sin(u_time)+1.,.7*cos(u_time)+1.);
    
    p1 = drawHall(vec2(st.x+mix(-.4,.3,0.3*sin(0.5*u_time)),st.y+mix(-.4,.3,0.3*cos(0.5*u_time))));
    p2 = drawHall(vec2(1.-st.x+mix(-.4,.3,-0.3*cos(0.5*u_time)),st.y+mix(-.4,.3,0.3*cos(0.5*u_time))));
    
    vec2 q = vec2(0.650,0.700);
    vec2 r = vec2(0.600,0.490);
    float var = pattern(st, q, r);
    
    vec3 col = vec3(0.0);
    col = mix( vec3(0.8314, 0.0706, 0.2745), vec3(0.296,0.590,0.271), var );
    col = mix( col, vec3(0.0,0.2,0.4), 0.5*smoothstep(1.2,1.3,0.) );
    col = 0.8 - col;

    color = p1*color*col*var+p2*color*var*col;
    
    gl_FragColor = vec4(color,1.0);
}