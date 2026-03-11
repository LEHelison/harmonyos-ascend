import { remoteDevice } from '@kit.NearLinkKit'

import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

// DeepSeek API 接口定义
interface DeepSeekMessage {
  role: string;
  content: string;
}

interface DeepSeekRequest {
  model: string;
  messages: DeepSeekMessage[];
  temperature?: number;
  max_tokens?: number;
  stream?: boolean;
}

interface DeepSeekChoice {
  index: number;
  message: DeepSeekMessage;
  finish_reason: string;
}

interface DeepSeekUsage {
  prompt_tokens: number;
  completion_tokens: number;
  total_tokens: number;
}

interface DeepSeekResponse {
  id: string;
  object: string;
  created: number;
  model: string;
  choices: DeepSeekChoice[];
  usage: DeepSeekUsage;
}
@Entry
@Component
export default struct damoxing {
  @State selectedIndex: number = 1
  @State currentIndex: number = 1
  @State inputText: string = '' // 用于绑定用户输入的内容
  @State messages: Array<Message> = [

  ]
  @State question: string = '';
  @State chatHistory: string = '欢迎使用AI咨询助手！\n请输入您的问题，我将为您提供专业的回答。\n\n';
  @State isLoading: boolean = false;
  @State conversationHistory: DeepSeekMessage[] = [];

  // DeepSeek API 配置
  private readonly API_KEY = 'sk-3b6bebb848b441a2b3a9126b6a80de0f';
  private readonly API_URL = 'https://api.deepseek.com/chat/completions';
  private readonly MODEL_NAME = 'deepseek-chat';

  private controller: TabsController = new TabsController()

  @Builder tabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title).fontColor(this.selectedIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  // 处理发送按钮点击事件
  handleSend() {
    if (this.inputText.trim() !== '') {
      console.log('发送的内容:', this.inputText) // 打印发送的内容
      // 这里可以添加发送逻辑，例如调用API或更新UI
      this.inputText = '' // 清空输入框
    } else {
      console.log('输入内容不能为空')
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.controller }) {


        TabContent() {
          Column(){

            // 顶部导航栏
            this.buildHeader()

            // 聊天显示区域
            this.buildChatArea()

            // 底部输入区域
            this.buildInputArea()

          }
          .width('100%').height('100%').backgroundColor(Color.White).justifyContent(FlexAlign.Center)
        }
        .tabBar(new BottomTabBarStyle($r('app.media.duihua'), "对话"))
        .margin({top:20})
        TabContent() {

          Column() {
            Row() {
              Button('<')
                .width(60)
                .height(36)
                .fontSize(18)
                .fontColor('#007AFF')
                .backgroundColor('#F0F8FF')
                .borderRadius(18)
                .onClick(() => {
                  console.log('点击事件触发');
                  router.pushUrl({url:'pages/zhu'})
                })

              Text('智能体')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .layoutWeight(1)
                .textAlign(TextAlign.Center)
                .margin({left:-50})

            }

            .width('100%')
            .height(56)
            .padding({ left: 16, right: 16 })
            .backgroundColor(Color.White)
            .shadow({
              radius: 4,
              color: '#1F000000',
              offsetX: 0,
              offsetY: 2
            })
            Tabs(){
              TabContent(){
                Row(){
                  Image($r('app.media.hetongshenhe'))
                    .height(50)
                    .width(50)
                    .margin({left:10,top:30})
                  Text('文档解析')
                    .margin({left:10,top:30})
                    .onClick(()=>{
                      console.log('点击事件触发');
                      router.pushUrl({url:'pages/DocumentParser'})
                    })

                }
                .margin({top:-500})
                .width('90%')
                .height(120)
                .backgroundColor(Color.White)
              }
              .tabBar('推荐')
              .margin({top:15})
              TabContent(){
                Row(){



                }
                .margin({top:-500})
                .width('90%')
                .height(120)
                .backgroundColor(Color.White)
              }
              .tabBar('文化')
              TabContent(){
                Row(){

                }
              }
              .tabBar('生活')
              TabContent(){
                Row(){

                }
              }
              .tabBar('教育')

            }

          }

          .width('100%')
          .height('100%')
          .backgroundColor('#f0f0f0')
          .justifyContent(FlexAlign.Center)
        }
        .tabBar(new BottomTabBarStyle($r('app.media.zhinengti'), "智能体"))
        .margin({ top: 20 })
        TabContent() {
          Column(){
            Row() {
              Button('<')
                .width(60)
                .height(36)
                .fontSize(18)
                .fontColor('#007AFF')
                .backgroundColor('#F0F8FF')
                .borderRadius(18)
                .onClick(() => {
                  console.log('点击事件触发');
                  router.pushUrl({url:'pages/zhu'})
                })

              Text('知识库')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .layoutWeight(1)
                .textAlign(TextAlign.Center)
                .margin({left:-50})


            }
            .width('100%')
            .height(56)
            .padding({ left: 16, right: 16 })
            .backgroundColor(Color.White)
            .shadow({
              radius: 4,
              color: '#1F000000',
              offsetX: 0,
              offsetY: 2
            })
            .margin({top:-450})

            .width('100%')
            .height(56)
            .padding({ left: 16, right: 16 })
            .backgroundColor(Color.White)
            .shadow({
              radius: 4,
              color: '#1F000000',
              offsetX: 0,
              offsetY: 2
            })
            Column(){
              Row(){
                Image($r('app.media.zhishiku'))
                  .width(60)
                  .height(50)
                  .onClick(()=>{
                    console.log('点击事件触发');
                    router.pushUrl({url:'pages/gongchangjianjie'})
                  })
                Text('工厂简介')

              }

              .width('90%')
              .height(120)
            }





          }
          .width('100%').height('100%').backgroundColor(Color.White).justifyContent(FlexAlign.Center)
        }
        .tabBar(new BottomTabBarStyle($r('app.media.zhishiku'), "知识库"))



      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth(360)
      .barHeight(60)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index
        this.selectedIndex = index
      })
      .width(360)
      .height(600)
      .backgroundColor(Color.White)
      .scrollable(true)

      .width('100%')
      .height('100%')

    }.width('100%')
    .height('100%')
  }
  @Builder
  SentMessage(msg: Message) {
    Row() {
      Column({ space: 4 }) {
        Text(msg.userName)
          .fontSize(12)
          .fontColor('#666')
          .align(Alignment.End)

        Text(msg.content)
          .padding(10)
          .backgroundColor('#9EEA6F')
          .borderRadius(12)
          .margin({ right: 8 })

        Text(msg.time)
          .fontSize(10)
          .fontColor('#999')
          .align(Alignment.End)
      }

      Image($r('app.media.zhangsan'))
        .width(40)
        .height(40)
        .borderRadius(20)
    }
    .justifyContent(FlexAlign.End)
    .margin({ right: 12, top: 8 })
    .width('100%')
  }

  // 接收消息布局保持不变

  @Builder
  ReceivedMessage(msg: Message) {
    Row() {
      Image(msg.avatar)
        .width(40)
        .height(40)
        .borderRadius(20)
        .margin({ right: 8 })

      Column({ space: 4 }) {
        Text(msg.userName)
          .fontSize(12)
          .fontColor('#666')

        Text(msg.content)
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(12)

        Text(msg.time)
          .fontSize(10)
          .fontColor('#999')
      }
    }
    .margin({ left: 12, top: 8 })
  }
  @Builder
  buildHeader() {
    Row() {
      Button('<')
        .width(60)
        .height(36)
        .fontSize(18)
        .fontColor('#007AFF')
        .backgroundColor('#F0F8FF')
        .borderRadius(18)
        .onClick(() => {
          console.log('点击事件触发');
          router.pushUrl({url:'pages/zhu'})
        })

      Text('AI咨询助手')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Button('清空')
        .width(60)
        .height(36)
        .fontSize(14)
        .fontColor('#FF3B30')
        .backgroundColor('#FFE6E6')
        .borderRadius(18)
        .onClick(() => {
          this.clearChat()
        })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .shadow({
      radius: 4,
      color: '#1F000000',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  buildChatArea() {
    Column() {
      Scroll() {
        Text(this.chatHistory)
          .width('100%')
          .fontSize(16)
          .lineHeight(24)
          .fontColor('#333333')
          .textAlign(TextAlign.Start)
          .padding(16)
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .margin({ top: 16, left: 16, right: 16 })

      // 加载状态
      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .color('#007AFF')
            .width(24)
            .height(24)
            .margin({ right: 8 })

          Text('AI正在思考中...')
            .fontSize(14)
            .fontColor('#666666')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding(16)
      }
    }
    .layoutWeight(1)
  }

  @Builder
  buildInputArea() {
    Column() {
      Row() {
        TextInput({
          placeholder: '请输入您的问题...',
          text: this.question
        })
          .layoutWeight(1)
          .height(48)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .borderRadius(24)
          .padding({ left: 16, right: 16 })
          .margin({ right: 12 })
          .maxLines(3)
          .onChange((value: string) => {
            this.question = value;
          })

        Button('发送')
          .width(80)
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(this.isLoading || this.question.trim() === '' ? '#CCCCCC' : '#007AFF')
          .fontColor(Color.White)
          .borderRadius(24)
          .enabled(!this.isLoading && this.question.trim() !== '')
          .onClick(() => {
            this.sendMessage();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })

      // API状态提示
      Text('由DeepSeek AI提供技术支持')
        .fontSize(12)
        .fontColor('#999999')
        .margin({ bottom: 8 })
    }
    .backgroundColor(Color.White)
    .shadow({
      radius: 8,
      color: '#1F000000',
      offsetX: 0,
      offsetY: -2
    })
  }

  // 发送消息
  private sendMessage(): void {
    if (this.question.trim() === '' || this.isLoading) {
      return;
    }

    const userQuestion = this.question.trim();
    this.question = '';

    // 添加用户问题到聊天历史
    this.chatHistory += `\n【您】: ${userQuestion}\n\n`;

    // 添加到对话历史
    this.conversationHistory.push({
      role: 'user',
      content: userQuestion
    });

    this.getDeepSeekResponse();
  }

  // 调用DeepSeek API
  private getDeepSeekResponse(): void {
    this.isLoading = true;
    this.chatHistory += '【AI咨询助手】: ';

    const httpRequest = http.createHttp();

    // 构建DeepSeek API请求数据
    const requestData: DeepSeekRequest = {
      model: this.MODEL_NAME,
      messages: [
        {
          role: 'system',
          content: '你是一个专业的AI助手，请用中文回答用户的问题，回答要准确、详细且有帮助。'
        },
        ...this.conversationHistory
      ],
      temperature: 0.7,
      max_tokens: 2000,
      stream: false
    };

    console.log('发送请求数据:', JSON.stringify(requestData));

    httpRequest.request(this.API_URL, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.API_KEY}`,
        'User-Agent': 'HarmonyOS-App/1.0'
      },
      extraData: JSON.stringify(requestData),
      connectTimeout: 30000,
      readTimeout: 60000
    }).then((response: http.HttpResponse) => {
      console.log('响应状态码:', response.responseCode);
      console.log('响应数据:', response.result);

      if (response.responseCode === 200) {
        try {
          const deepSeekResponse: DeepSeekResponse = JSON.parse(response.result as string);

          if (deepSeekResponse.choices && deepSeekResponse.choices.length > 0) {
            const aiAnswer = deepSeekResponse.choices[0].message.content;

            // 添加AI回答到聊天历史
            this.chatHistory += `${aiAnswer}\n\n`;

            // 添加到对话历史
            this.conversationHistory.push({
              role: 'assistant',
              content: aiAnswer
            });

            // 限制对话历史长度（保留最近10轮对话）
            if (this.conversationHistory.length > 20) {
              this.conversationHistory = this.conversationHistory.slice(-20);
            }

            promptAction.showToast({
              message: '回答已生成',
              duration: 1500
            });
          } else {
            throw new Error('AI回复格式错误: 未找到choices字段');
          }
        } catch (parseError) {
          console.error('解析响应数据失败:', parseError);
          this.chatHistory += '抱歉，解析AI回复时出现错误。\n\n';
        }
      } else if (response.responseCode === 401) {
        this.chatHistory += '抱歉，API密钥无效，请检查您的授权信息。\n\n';
      } else if (response.responseCode === 429) {
        this.chatHistory += '抱歉，请求过于频繁，请稍后再试。\n\n';
      } else {
        this.chatHistory += `抱歉，API请求失败: ${response.responseCode}\n\n`;
      }

      this.isLoading = false;
    }).catch((error: BusinessError) => {
      console.error('DeepSeek API 错误:', error);

      let errorMessage = '抱歉，AI服务暂时不可用，请稍后再试。\n\n';

      if (error.message) {
        console.error('错误详情:', error.message);

        if (error.message.includes('timeout')) {
          errorMessage = '抱歉，请求超时，请检查网络连接。\n\n';
        } else if (error.message.includes('network')) {
          errorMessage = '抱歉，网络连接失败，请检查网络设置。\n\n';
        } else {
          errorMessage = `抱歉，服务出现问题: ${error.message}\n\n`;
        }
      }

      this.chatHistory += errorMessage;

      promptAction.showToast({
        message: '请求失败，请重试',
        duration: 2000
      });

      this.isLoading = false;
    });
  }

  // 清空聊天记录
  private clearChat(): void {
    AlertDialog.show({
      title: '确认清空',
      message: '确定要清空所有聊天记录吗？',
      primaryButton: {
        value: '确定',
        fontColor: '#FF3B30',
        action: () => {
          this.chatHistory = '欢迎使用DeepSeek AI助手！\n请输入您的问题，我将为您提供专业的回答。\n\n';
          this.conversationHistory = [];
          promptAction.showToast({
            message: '聊天记录已清空',
            duration: 1500
          });
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {}
      }
    });
  }

}

class Message {
  direction: string
  avatar: string
  userName: string
  content: string
  time: string

  constructor(direction: string, avatar: string, userName: string, content: string, time: string) {
    this.direction = direction
    this.avatar = avatar
    this.userName = userName
    this.content = content
    this.time = time
  }
}

