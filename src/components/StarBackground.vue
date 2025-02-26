<template>
  <div class="star-background">
    <div class="stars-container">
      <!-- 小星星层 -->
      <div class="stars small"></div>
      <!-- 中等星星层 -->
      <div class="stars medium"></div>
      <!-- 大星星层 -->
      <div class="stars large"></div>
      <!-- 流星层 - 超强版 -->
      <div class="meteors-container">
        <div class="meteor" v-for="n in 15" :key="n"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
// 仅作为视觉效果组件，不包含特殊逻辑
</script>

<style scoped>
.star-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 10; /* 确保在最上层 */
  pointer-events: none;
  overflow: hidden;
}

.stars-container {
  position: absolute;
  width: 100%;
  height: 100%;
  background: transparent;
}

/* 星星样式保持不变 */
.stars {
  position: absolute;
  width: 1px;
  height: 1px;
  background: transparent;
}

/* 小星星 */
.stars.small {
  width: 1px;
  height: 1px;
  box-shadow:
    5px 5px rgba(255, 255, 255, 0.8),
    25px 15px rgba(255, 255, 255, 0.9),
    50px 35px rgba(255, 255, 255, 1),
    80px 40px rgba(255, 255, 255, 0.8),
    15px 55px rgba(255, 255, 255, 0.9),
    20px 85px rgba(255, 255, 255, 1),
    35px 125px rgba(255, 255, 255, 0.8),
    55px 170px rgba(255, 255, 255, 0.9),
    65px 185px rgba(255, 255, 255, 1),
    75px 220px rgba(255, 255, 255, 0.9),
    95px 240px white,
    120px 270px white,
    150px 290px white,
    180px 280px white,
    195px 320px white,
    220px 20px white,
    240px 50px white,
    280px 85px white,
    320px 120px white,
    340px 150px white,
    370px 180px white,
    390px 220px white,
    410px 250px white,
    440px 290px white,
    470px 320px white,
    510px 350px white,
    530px 370px white,
    550px 390px white,
    570px 420px white,
    590px 460px white,
    160px 340px white,
    200px 370px white,
    230px 410px white,
    270px 430px white,
    300px 450px white,
    320px 480px white,
    350px 500px white,
    380px 540px white,
    420px 580px white,
    450px 600px white,
    480px 630px white,
    520px 650px white,
    550px 680px white,
    580px 700px white,
    610px 720px white,
    640px 40px white,
    680px 80px white,
    720px 110px white,
    750px 140px white,
    780px 170px white,
    810px 200px white,
    840px 230px white,
    870px 260px white,
    900px 290px white,
    930px 320px white,
    960px 350px white,
    990px 380px white,
    1020px 410px white,
    1050px 440px white,
    1080px 470px white,
    1100px 490px white,
    1130px 520px white,
    1160px 550px white,
    1190px 580px white,
    1220px 610px white,
    1240px 630px white,
    1270px 660px white,
    1300px 690px white,
    1330px 720px white,
    1360px 750px white,
    630px 210px white,
    660px 240px white,
    690px 270px white,
    720px 300px white,
    750px 330px white,
    780px 360px white,
    810px 390px white,
    840px 420px white,
    870px 450px white,
    900px 480px white,
    930px 510px white,
    960px 540px white,
    990px 570px white,
    1020px 600px white,
    1050px 630px white;
  animation: animateStars 100s linear infinite;
}

/* 中等星星 */
.stars.medium {
  width: 2px;
  height: 2px;
  animation: twinkle 5s ease-in-out infinite alternate;
}

/* 大星星 */
.stars.large {
  width: 3px;
  height: 3px;
  animation: twinkle 7s ease-in-out infinite alternate;
}

/* 确保流星容器在最上层 */
.meteors-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 9999; /* 极高的z-index确保在所有元素之上 */
  overflow: visible;
  pointer-events: none; /* 确保不影响交互 */
}

/* 优化的流星动画 */
@keyframes meteorFall {
  0% {
    transform: translateX(0) translateY(0) rotate(-45deg);
    opacity: 0;
    width: 0;
    height: 0;
  }
  3% {
    opacity: 1;
    width: 800px;
    height: 12px;
  }
  15% {
    opacity: 1;
  }
  25% {
    transform: translateX(-500px) translateY(500px) rotate(-45deg);
    opacity: 0.7;
    box-shadow: 0 0 20px 10px rgba(255, 255, 255, 0.8);
  }
  40% {
    opacity: 0;
  }
  100% {
    transform: translateX(-1500px) translateY(1500px) rotate(-45deg);
    opacity: 0;
  }
}

/* 提高动画频率 */
.meteor {
  position: absolute;
  width: 800px;
  height: 12px; /* 进一步增加高度 */
  background: linear-gradient(90deg, rgba(255, 255, 255, 1), rgba(255, 255, 255, 0));
  opacity: 0;
  transform: rotate(-45deg);
  border-radius: 999px;
  filter: drop-shadow(0 0 15px #ffffff); /* 更强的辉光 */
  z-index: 9999;
  animation: meteorFall 1.5s ease-in infinite; /* 缩短动画时间 */
  will-change: transform, opacity; /* 性能优化 */
}

/* 为每个流星设置不同起始位置 */
.meteor:nth-child(1) {
  top: 10%;
  right: -100px;
  animation-delay: 0s;
}

.meteor:nth-child(2) {
  top: 20%;
  right: -150px;
  animation-delay: 0.4s;
}

.meteor:nth-child(3) {
  top: 15%;
  right: -200px;
  animation-delay: 0.8s;
}

.meteor:nth-child(4) {
  top: 30%;
  right: -120px;
  animation-delay: 1.2s;
}

.meteor:nth-child(5) {
  top: 25%;
  right: -180px;
  animation-delay: 1.6s;
}

.meteor:nth-child(6) {
  top: 35%;
  right: -150px;
  animation-delay: 2s;
}

.meteor:nth-child(7) {
  top: 40%;
  right: -100px;
  animation-delay: 2.4s;
}

.meteor:nth-child(8) {
  top: 5%;
  right: -180px;
  animation-delay: 2.8s;
}

.meteor:nth-child(9) {
  top: 12%;
  right: -120px;
  animation-delay: 3.2s;
}

.meteor:nth-child(10) {
  top: 8%;
  right: -190px;
  animation-delay: 3.6s;
}

.meteor:nth-child(11) {
  top: 28%;
  right: -140px;
  animation-delay: 4s;
}

.meteor:nth-child(12) {
  top: 32%;
  right: -160px;
  animation-delay: 4.4s;
}

.meteor:nth-child(13) {
  top: 18%;
  right: -130px;
  animation-delay: 4.8s;
}

.meteor:nth-child(14) {
  top: 22%;
  right: -180px;
  animation-delay: 5.2s;
}

.meteor:nth-child(15) {
  top: 3%;
  right: -110px;
  animation-delay: 5.6s;
}

/* 更强的流星尾巴 */
.meteor::after {
  content: '';
  position: absolute;
  top: -5px;
  right: 0;
  width: 80px; /* 更长的尾巴 */
  height: 22px; /* 更宽的尾巴 */
  border-radius: 100%;
  background: rgba(255, 255, 255, 0.8);
  box-shadow:
    0 0 60px 25px rgba(255, 255, 255, 0.9),
    0 0 100px 40px rgba(255, 255, 255, 0.5); /* 更强烈的光晕 */
}

/* 原始星星动画保持不变 */
@keyframes animateStars {
  0% {
    transform: translateY(0) rotateZ(0);
    opacity: 1;
  }
  100% {
    transform: translateY(-2000px) rotateZ(360deg);
    opacity: 1;
  }
}

@keyframes twinkle {
  0% {
    opacity: 0.5;
    box-shadow:
      5px 5px rgba(255, 255, 255, 0.8),
      25px 15px rgba(255, 255, 255, 0.9),
      50px 35px rgba(255, 255, 255, 1),
      80px 40px rgba(255, 255, 255, 0.8),
      15px 55px rgba(255, 255, 255, 0.9),
      20px 85px rgba(255, 255, 255, 1),
      35px 125px rgba(255, 255, 255, 0.8),
      55px 170px rgba(255, 255, 255, 0.9),
      65px 185px rgba(255, 255, 255, 1),
      75px 220px rgba(255, 255, 255, 0.9),
      95px 240px white,
      120px 270px white,
      150px 290px white,
      180px 280px white,
      195px 320px white,
      220px 20px white,
      240px 50px white,
      280px 85px white,
      320px 120px white,
      340px 150px white,
      370px 180px white,
      390px 220px white,
      410px 250px white,
      440px 290px white,
      470px 320px white,
      510px 350px white,
      530px 370px white,
      550px 390px white,
      570px 420px white,
      590px 460px white,
      160px 340px white,
      200px 370px white,
      230px 410px white,
      270px 430px white,
      300px 450px white,
      320px 480px white,
      350px 500px white,
      380px 540px white,
      420px 580px white,
      450px 600px white,
      480px 630px white,
      520px 650px white,
      550px 680px white,
      580px 700px white,
      610px 720px white,
      640px 40px white,
      680px 80px white,
      720px 110px white,
      750px 140px white,
      780px 170px white,
      810px 200px white,
      840px 230px white,
      870px 260px white,
      900px 290px white,
      930px 320px white,
      960px 350px white,
      990px 380px white,
      1020px 410px white,
      1050px 440px white,
      1080px 470px white,
      1100px 490px white,
      1130px 520px white,
      1160px 550px white,
      1190px 580px white,
      1220px 610px white,
      1240px 630px white,
      1270px 660px white,
      1300px 690px white,
      1330px 720px white,
      1360px 750px white,
      630px 210px white,
      660px 240px white,
      690px 270px white,
      720px 300px white,
      750px 330px white,
      780px 360px white,
      810px 390px white,
      840px 420px white,
      870px 450px white,
      900px 480px white,
      930px 510px white,
      960px 540px white,
      990px 570px white,
      1020px 600px white,
      1050px 630px white;
  }
  50% {
    opacity: 1;
    box-shadow:
      5px 5px rgba(255, 255, 255, 0.8),
      25px 15px rgba(255, 255, 255, 0.9),
      50px 35px rgba(255, 255, 255, 1),
      80px 40px rgba(255, 255, 255, 0.8),
      15px 55px rgba(255, 255, 255, 0.9),
      20px 85px rgba(255, 255, 255, 1),
      35px 125px rgba(255, 255, 255, 0.8),
      55px 170px rgba(255, 255, 255, 0.9),
      65px 185px rgba(255, 255, 255, 1),
      75px 220px rgba(255, 255, 255, 0.9),
      95px 240px white,
      120px 270px white,
      150px 290px white,
      180px 280px white,
      195px 320px white,
      220px 20px white,
      240px 50px white,
      280px 85px white,
      320px 120px white,
      340px 150px white,
      370px 180px white,
      390px 220px white,
      410px 250px white,
      440px 290px white,
      470px 320px white,
      510px 350px white,
      530px 370px white,
      550px 390px white,
      570px 420px white,
      590px 460px white,
      160px 340px white,
      200px 370px white,
      230px 410px white,
      270px 430px white,
      300px 450px white,
      320px 480px white,
      350px 500px white,
      380px 540px white,
      420px 580px white,
      450px 600px white,
      480px 630px white,
      520px 650px white,
      550px 680px white,
      580px 700px white,
      610px 720px white,
      640px 40px white,
      680px 80px white,
      720px 110px white,
      750px 140px white,
      780px 170px white,
      810px 200px white,
      840px 230px white,
      870px 260px white,
      900px 290px white,
      930px 320px white,
      960px 350px white,
      990px 380px white,
      1020px 410px white,
      1050px 440px white,
      1080px 470px white,
      1100px 490px white,
      1130px 520px white,
      1160px 550px white,
      1190px 580px white,
      1220px 610px white,
      1240px 630px white,
      1270px 660px white,
      1300px 690px white,
      1330px 720px white,
      1360px 750px white,
      630px 210px white,
      660px 240px white,
      690px 270px white,
      720px 300px white,
      750px 330px white,
      780px 360px white,
      810px 390px white,
      840px 420px white,
      870px 450px white,
      900px 480px white,
      930px 510px white,
      960px 540px white,
      990px 570px white,
      1020px 600px white,
      1050px 630px white;
  }
  100% {
    opacity: 0.8;
    box-shadow:
      5px 5px rgba(255, 255, 255, 0.8),
      25px 15px rgba(255, 255, 255, 0.9),
      50px 35px rgba(255, 255, 255, 1),
      80px 40px rgba(255, 255, 255, 0.8),
      15px 55px rgba(255, 255, 255, 0.9),
      20px 85px rgba(255, 255, 255, 1),
      35px 125px rgba(255, 255, 255, 0.8),
      55px 170px rgba(255, 255, 255, 0.9),
      65px 185px rgba(255, 255, 255, 1),
      75px 220px rgba(255, 255, 255, 0.9),
      95px 240px white,
      120px 270px white,
      150px 290px white,
      180px 280px white,
      195px 320px white,
      220px 20px white,
      240px 50px white,
      280px 85px white,
      320px 120px white,
      340px 150px white,
      370px 180px white,
      390px 220px white,
      410px 250px white,
      440px 290px white,
      470px 320px white,
      510px 350px white,
      530px 370px white,
      550px 390px white,
      570px 420px white,
      590px 460px white,
      160px 340px white,
      200px 370px white,
      230px 410px white,
      270px 430px white,
      300px 450px white,
      320px 480px white,
      350px 500px white,
      380px 540px white,
      420px 580px white,
      450px 600px white,
      480px 630px white,
      520px 650px white,
      550px 680px white,
      580px 700px white,
      610px 720px white,
      640px 40px white,
      680px 80px white,
      720px 110px white,
      750px 140px white,
      780px 170px white,
      810px 200px white,
      840px 230px white,
      870px 260px white,
      900px 290px white,
      930px 320px white,
      960px 350px white,
      990px 380px white,
      1020px 410px white,
      1050px 440px white,
      1080px 470px white,
      1100px 490px white,
      1130px 520px white,
      1160px 550px white,
      1190px 580px white,
      1220px 610px white,
      1240px 630px white,
      1270px 660px white,
      1300px 690px white,
      1330px 720px white,
      1360px 750px white,
      630px 210px white,
      660px 240px white,
      690px 270px white,
      720px 300px white,
      750px 330px white,
      780px 360px white,
      810px 390px white,
      840px 420px white,
      870px 450px white,
      900px 480px white,
      930px 510px white,
      960px 540px white,
      990px 570px white,
      1020px 600px white,
      1050px 630px white;
  }
}
</style>
