<script setup>
import { ref, onMounted, watch } from 'vue'
import { WebGLUtility, ShaderProgram } from '@/scripts/webgl.js'
import vertexShaderSource from './shaders/vert.glsl?raw'
import fragmentShaderSource from './shaders/frag.glsl?raw'
const baseUrl = import.meta.env.BASE_URL

const canvas = ref(null)

let gl = null
let shaderProgram = null
const vbo = []
const positions = []
const colors = []
const mousePos = [0.0, 0.0]
const mouseEntered = ref(false)

let useMouseEnter, useMouseLeave

const init = () => {
  canvas.value.width = window.innerWidth
  canvas.value.height = window.innerHeight

  window.addEventListener('resize', resize)

  const params = new URLSearchParams(location.search)
  useMouseEnter = params.has('mouseenter')
  useMouseLeave = params.has('mouseleave')
  if (!useMouseEnter) mouseEntered.value = true
}

const setMousePosition = (event) => {
  if (event) {
    let x, y
    if (event.changedTouches) {
      x = event.changedTouches[0].clientX
      y = event.changedTouches[0].clientY
    } else {
      x = event.clientX
      y = event.clientY
    }
    mousePos[0] = (x / canvas.value.width) * 2 - 1.0
    mousePos[1] = -((y / canvas.value.height) * 2 - 1.0)
  }

  shaderProgram.use()
  shaderProgram.setUniform([mousePos, mouseEntered.value])
}

const load = () => {
  gl = canvas.value.getContext('webgl')

  shaderProgram = new ShaderProgram(gl, {
    vertexShaderSource,
    fragmentShaderSource,
    attribute: ['position', 'color'],
    stride: [2, 4],
    uniform: ['mousePos', 'mouseEntered'],
    type: ['uniform2fv', 'uniform1i'],
  })

  setMousePosition()
  canvas.value.addEventListener('mousemove', setMousePosition)
  canvas.value.addEventListener('touchmove', setMousePosition)
  if (useMouseEnter) {
    canvas.value.addEventListener('mouseenter', () => {
      mouseEntered.value = true
    })
    canvas.value.addEventListener('touchstart', () => {
      mouseEntered.value = true
    })
  }
  if (useMouseLeave) {
    canvas.value.addEventListener('mouseleave', () => {
      mouseEntered.value = false
    })
    canvas.value.addEventListener('touchend', () => {
      mouseEntered.value = false
    })
  }
}

watch(mouseEntered, (newValue) => {
  shaderProgram.use()
  shaderProgram.setUniform([mousePos, mouseEntered.value])
})

const setup = async () => {
  await setupGeometry()
  gl.clearColor(0.0, 0.0, 0.05, 1.0)
}

const loadImage = (url) => {
  return new Promise((resolve) => {
    const img = new Image()
    img.addEventListener('load', () => {
      const canvas = document.createElement('canvas')
      canvas.width = img.width
      canvas.height = img.height
      const ctx = canvas.getContext('2d')
      ctx.drawImage(img, 0, 0)
      resolve(ctx.getImageData(0, 0, img.width, img.height))
    })
    img.src = url
  })
}

const setupGeometry = async () => {
  const imageData = await loadImage(`${baseUrl}/tasks/01_3/halloween_chara1_pumpkin.png`)
  // 場所決める
  const w = imageData.width
  const h = imageData.height
  const d = imageData.data
  for (let x = 0; x < w; x += 5) {
    const xVal = (x / w) * 2 - 1 + 1 / w
    for (let y = 0; y < h; y += 5) {
      const yVal = 2 - (y / h) * 2 - 1 + 1 / h
      positions.push(xVal)
      positions.push(yVal)
      const offset = y * w + x
      colors.push(d[offset * 4 + 0] / 255)
      colors.push(d[offset * 4 + 1] / 255)
      colors.push(d[offset * 4 + 2] / 255)
      colors.push(d[offset * 4 + 3] / 255)
    }
  }
  vbo[0] = WebGLUtility.createVbo(gl, positions)
  vbo[1] = WebGLUtility.createVbo(gl, colors)
  shaderProgram.use()
  shaderProgram.setAttribute(vbo)
}

const render = () => {
  gl.viewport(0, 0, canvas.value.width, canvas.value.height)
  gl.clear(gl.COLOR_BUFFER_BIT)

  gl.drawArrays(gl.POINTS, 0, positions.length / 2)

  requestAnimationFrame(render)
}

const resize = () => {
  canvas.value.width = window.innerWidth
  canvas.value.height = window.innerHeight
}

onMounted(async () => {
  init()
  await load()
  await setup()
  render()
})
</script>

<template>
  <canvas ref="canvas" id="canvas"></canvas>
  <figure>
    <img :src="`${baseUrl}/tasks/01_3/halloween_chara1_pumpkin.png`" />
    <figcaption><a href="https://www.irasutoya.com/2018/10/blog-post_890.html" target="_blank" noopener>いらすとや</a></figcaption>
  </figure>
</template>

<style scoped>
#canvas {
  position: absolute;
  top: 0;
  left: 0;
}
figure {
  position: absolute;
  bottom: 0;
  right: 0;
  background-color: #000;
  border: 1px solid #fff;
  border-radius: 5px;
  margin: 0;
}
img {
  position: relative;
  width: 100px;
}
figcaption {
  position: absolute;
  bottom: 5px;
  width: 100%;
  text-align: center;
  color: #fff;
}
figcaption a {
  color: #fff;
}
</style>
