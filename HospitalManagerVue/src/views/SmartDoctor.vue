<template>
  <div class="message_info">
    <JwChat
      class="jwchat"
      ref="jwChat"
      v-model="inputMsg"
      :config="config"
      :taleList="list"
      :scrollType="scrollType"
      :toolConfig="tool"
      :placeholder="placeholder"
      :quickList="quickList"
      @enter="bindEnter"
      @clickTalk="talkEvent"
    >
      <!-- <template slot="enter">
        <div>自定义输入框</div>
      </template> -->
      <template slot="enterBtn">
        <div><el-button type="primary" @click="sendMessage()">发送</el-button></div>
      </template>
      <!-- <template #downBtn="{unread}">
    <div>
      未读{{unread}}
    </div>
  </template> -->
      <!-- <template #talkItem="{ data }">
        自定义对话框{{ data }}
      </template> -->
      <!-- <template slot="tools">
    <div style="width: 20rem; text-align: right" @click="toolEvent(12)">
      <JwChat-icon type="icon-lishi" title="自定义" />
    </div>
  </template> -->
    </JwChat>
  </div>
</template>
<script>
import request from "@/utils/request.js";
import jwtDecode from "jwt-decode";
import {
    getToken
} from "@/utils/storage.js";
export default {
  data() {
    name: "smartDoctor";
    return {
      userName:"",
      scrollType: "noroll", // scroll  noroll 俩种类型
      placeholder: "请输入您的症状",
      inputMsg: "",
      taleList: [],
      list: [],
      tool: {
        callback: this.toolEvent,
      },
      quickList: [
        { text: "白血病怎么治" },
      ],
      config: {
        historyConfig: {
          show: false,
          tip: "加载更多信息",
          callback: this.bindLoadHistory(),
        },
      },
    };
  },
  methods: {
    tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
    sendMessage(){
        
        request
                .post("message/query", {
                    content: this.inputMsg
                })
                .then((res) => {
                    const doctorData = res.data.msg;
                    console.log(res.data.msg)
                    const date = new Date();
                    const formattedDate = `${date.getFullYear()}/${('0' + (date.getMonth() + 1)).slice(-2)}/${('0' + date.getDate()).slice(-2)} ${('0' + date.getHours()).slice(-2)}:${('0' + date.getMinutes()).slice(-2)}:${('0' + date.getSeconds()).slice(-2)}`;
                    const msgObj = {
                        date: formattedDate,
                        text: { text: doctorData },
                        mine: false,
                        name: "小智",
                        img: require("../assets/ai.jpg")
                    };
                    this.list.push(msgObj);
                    this.taleList.push(msgObj);
                });
    },
    /**
     * @description: 点击加载更多的回调函数
     * @param {*}
     * @return {*}
     */
    async bindLoadHistory() {
    //   const history = new Array(3).fill().map((i, j) => {
    //     const date = new Date();
    //     const formattedDate = `${date.getFullYear()}/${('0' + (date.getMonth() + 1)).slice(-2)}/${('0' + date.getDate()).slice(-2)} ${('0' + date.getHours()).slice(-2)}:${('0' + date.getMinutes()).slice(-2)}:${('0' + date.getSeconds()).slice(-2)}`;
    //     return {
    //       date: formattedDate,
    //       text: { text: "您好，我是你的智能医生小智，请问您需要询问我什么？" },
    //       mine: false,
    //       name: "小智",
    //       img: require("../assets/doctor.jpeg"),
    //     //   img: require("../assets/ai.jpg"),
    //       list: [],
    //     };
    //   });
    //   let list = history.concat(this.taleList);
    //   this.taleList = list;
    //   console.log("加载历史", list, history);
    //   //  加载完成后通知组件关闭加载动画
    //   this.config.historyConfig.tip = "加载完成";
    //   this.$nextTick(() => {
    //     this.$refs.jwChat.finishPullDown();
    //   });
    },
    bindEnter(e) {
      console.log(e);
      const msg = this.inputMsg;
      if (!msg) return;
      const date = new Date();
      const userName = this.userName
      console.log("username", this.userName)
      const formattedDate = `${date.getFullYear()}/${('0' + (date.getMonth() + 1)).slice(-2)}/${('0' + date.getDate()).slice(-2)} ${('0' + date.getHours()).slice(-2)}:${('0' + date.getMinutes()).slice(-2)}:${('0' + date.getSeconds()).slice(-2)}`;
      const msgObj = {
        date: formattedDate,
        text: { text: msg },
        mine: true,
        name: userName,
        img: require("../assets/doctor.jpeg"),
      };
      this.list.push(msgObj);
      this.taleList.push(msgObj);
      this.sendMessage(msg)
    },
    toolEvent(type, obj) {
      console.log("tools", type, obj);
    },
    talkEvent(play) {
      console.log(play);
    },
  },
  mounted() {
    const date = new Date();
    const formattedDate = `${date.getFullYear()}/${('0' + (date.getMonth() + 1)).slice(-2)}/${('0' + date.getDate()).slice(-2)} ${('0' + date.getHours()).slice(-2)}:${('0' + date.getMinutes()).slice(-2)}:${('0' + date.getSeconds()).slice(-2)}`;
    const list = [
      {
        date: formattedDate ,
        text: { text: "您好，我是你的智能医生小智，请问您需要询问我什么？" },
        mine: false,
        name: "小智",
        img: require("../assets/ai.jpg")
        // "custom": true, // 自定义对话框开关
      },
    ];
    this.list = list;
    this.taleList.push(list);
    console.log(this.taleList)
  },
  created() {
        // 解码token
        this.userName = this.tokenDecode(getToken()).aName;
    }
};
</script>
<style scoped lang="scss">
.message_info {
  background-color: rgb(41, 50, 102);
}
.jwchat {
  border: 1px solid #ccc;
  border-radius: 5px;
}
</style>