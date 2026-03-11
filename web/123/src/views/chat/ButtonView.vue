<template>
  <img class="fix-box" @click="$emit('open-assistant')" src="@/assets/imgs/Service.png">
</template>
<script setup>
</script>
<style>
.fix-box{
  width: 60px;
  height: 60px;
  border-radius: 50%;
  text-align: center;
  bottom:3%;
  right: 2%;
  position:fixed;
  z-index:100;
}
</style>