<script setup>
import { ref, onMounted } from 'vue'
import { WebGLUtility, ShaderProgram } from '@/scripts/webgl.js'
import vertexShaderSource from './shaders/vert.glsl?raw'
import fragmentShaderSource from './shaders/frag.glsl?raw'
const canvas = ref(null)

let gl = null
let shaderProgram = null
const vbo = []
const positions = []
let counter = 0

const init = () => {
  canvas.value.width = window.innerWidth
  canvas.value.height = window.innerHeight

  window.addEventListener('resize', resize)
}

const load = () => {
  gl = canvas.value.getContext('webgl')

  shaderProgram = new ShaderProgram(gl, {
    vertexShaderSource,
    fragmentShaderSource,
    attribute: ['position'],
    stride: [3],
  })
}

const setup = () => {
  setupGeometry()
  gl.clearColor(0.1, 0.1, 0.1, 1.0)
}

const setupGeometry = () => {
  // 場所決める
  const size = 50
  for (let x = 0; x < size; x++) {
    const xVal = (x / size) * 2 - 1 + 1 / size
    for (let y = 0; y < size; y++) {
      const yVal = (y / size) * 2 - 1 + 1 / size
      positions.push(xVal)
      positions.push(yVal)
      positions.push(0)
    }
  }
  vbo[0] = WebGLUtility.createVbo(gl, positions)
}

const render = () => {
  gl.viewport(0, 0, canvas.value.width, canvas.value.height)
  gl.clear(gl.COLOR_BUFFER_BIT)

  shaderProgram.use()
  shaderProgram.setAttribute(vbo)

  counter += 3
  counter = counter % (positions.length / 3)

  gl.drawArrays(gl.POINTS, 0, counter)

  requestAnimationFrame(render)
}

const resize = () => {
  canvas.value.width = window.innerWidth
  canvas.value.height = window.innerHeight
}

onMounted(() => {
  init()
  load()
  setup()
  render()
})
</script>

<template>
  <canvas ref="canvas" id="canvas"></canvas>
</template>
