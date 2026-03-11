<template>
  <div class="chat-header">
    <div style="background: #409eff;height: 40px;width: 100%;text-align: center;padding-top: 20px">智能客服</div>
    <ul infinite-scroll-distance="1" v-infinite-scroll="load" class="infinite-list" style="overflow: auto">
      <div ref="chatList" class="execInfo">
        <div v-for="(item, index) in ChatHistory" :key="index">
          <div v-if="item.user!==''">
            <div class="right-data">
              <div style="margin-top: 15px;font-size: 20px">{{ userdata.username }}</div>
              <div><img src="@/assets/imgs/1212.jpg" style="width: 50px;height: 50px;border-radius: 50%"/></div>
            </div>
            <div class="texts-user">{{ item.user }}
            </div>
          </div>
          <div>
            <div style="display: flex;margin-left: 10px;margin-top: 40px">
              <img src="@/assets/imgs/1212.jpg" style="width: 50px;height: 50px;border-radius: 50%"/>
              <div style="margin-top: 15px;margin-left: 10px">机器人客服</div>
            </div>
            <div class="texts">{{ item.chat }}
            </div>
          </div>
        </div>
      </div>
    </ul>
    <div class="userinfo" style="display: flex">
      <el-input v-model="userinfo" @keyup.enter="handBangd" placeholder="有什么问题可以问我哦"/>
      <el-button style="margin-left: 20px" @click="handBangd" type="primary">发送</el-button>
    </div>
  </div>
</template>
<script setup>
import {ref, onMounted, watchEffect, nextTick, watch} from "vue";
import axios from "axios";
 
const count = ref(10)
const isLoading = ref(false);
const chatList = ref();
const datas = ref("")
const userinfo = ref('')
const ChatHistory = ref([{"user": userinfo.value, "chat": "欢迎使用****系统"},
  {"user": userinfo.value, "chat": "您好有什么能帮到你？"}])
 
watch(() => ChatHistory.value.length, () => {
  nextTick(() => {
    scrollBottom();
  })
})
const scrollBottom = () => {
  chatList.value.scrollTop = chatList.value.scrollHeight;
}
const load = (data) => {
 
}
 
let userdata = JSON.parse(localStorage.getItem("userData"))
const handBangd = async () => {
  if (userinfo.value === "") {
    ChatHistory.value.push({
      "user": userinfo.value,
      "chat": "还有什么问题吗？小丽可是很忙的哦，没有问题的话小丽就先走了哦"
    })
  } else {
    await axios({
        //appid是我们之前复制的那一个机器人Id
      url: `c18928ae65f1488db8dc3d2ee6500aae
    ${encodeURIComponent(userinfo.value)}`,
      method: "get",
    }).then(res => {
      datas.value = res.data.data.info.text
      ChatHistory.value.push({"user": userinfo.value, "chat": datas.value})
      console.log(ChatHistory.value)
      userinfo.value = ''
      isLoading.value = false;
    }).catch(error => {
      console.log(error.error)
    })
  }
 
}
 
</script>
<style>
.chat-header {
  position: relative;
  width: 100%;
  height: 600px;
  background: #AEEEEE;
  border: 1px solid lavender;
}
 
.execInfo {
  width: 100%;
  height: 450px;
  font-size: 16px;
  line-height: 33px;
  color: #606266;
  overflow-y: auto;
}
 
.userinfo {
  margin-left: 20px;
  width: 90%;
  bottom: 10px;
}
 
.infinite-list {
  height: 500px;
  padding: 0;
  margin: 0;
  list-style: none;
}
 
.infinite-list .infinite-list-item {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 50px;
  background: var(--el-color-primary-light-9);
  margin: 10px;
  color: var(--el-color-primary);
}
 
.infinite-list .infinite-list-item + .list-item {
  margin-top: 10px;
}
 
.heidde {
  position: absolute;
  width: 790px;
  overscroll-behavior: contain;
  overflow: auto;
  height: 480px;
  border: 2px solid darkgrey;
}
 
.texts {
  margin-left: 70px;
  background: white;
  display: inline-block;
  max-width: 70%;
  border-radius: 7px;
}
 
.right-data {
  margin-right: 10px;
  display: flex;
  justify-content: flex-end;
}
 
.texts-user {
  margin-right: 60px;
  margin-top: 100px;
  background: white;
  display: inline-block;
  text-align: right;
  max-width: 60%;
  border-radius: 7px;
}
 
 
</style>