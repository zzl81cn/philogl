#define LIGHT_MAX 50

attribute vec3 position;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 texCoord1;

uniform mat4 modelViewMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

uniform bool enableLights;
uniform vec3 ambientColor;
uniform vec3 directionalColor;
uniform vec3 lightingDirection;

uniform vec3 pointLocation[LIGHT_MAX];
uniform vec3 pointColor[LIGHT_MAX];
uniform int numberPoints;
uniform vec4 colorUfm;

varying vec4 vColor;
varying vec2 vTexCoord;
varying vec3 lightWeighting;

void main(void) {
  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
  
  if(!enableLights) {
    lightWeighting = vec3(1.0, 1.0, 1.0);
  } else {
    vec3 plightDirection;
    vec3 pointWeight = vec3(0.0, 0.0, 0.0);
    vec4 transformedNormal = normalMatrix * vec4(normal, 1.0);
    float directionalLightWeighting = max(dot(transformedNormal.xyz, lightingDirection), 0.0);
    for (int i = 0; i < LIGHT_MAX; i++) {
      if (i < numberPoints) {
        plightDirection = normalize((viewMatrix * vec4(pointLocation[i], 1.0)).xyz - mvPosition.xyz);
        pointWeight += max(dot(transformedNormal.xyz, plightDirection), 0.0) * pointColor[i];
      } else {
        break;
      }
    }

    lightWeighting = ambientColor + (directionalColor * directionalLightWeighting) + pointWeight;
  }
  
  vColor = colorUfm;
  vTexCoord = texCoord1;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
