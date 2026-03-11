import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { picker } from '@kit.CoreFileKit';
// 修正：使用正确的文件系统模块导入路径
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import pasteboard from '@ohos.pasteboard';
import { fileUri } from '@kit.CoreFileKit';
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import fileIo from '@ohos.fileio';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    let context = this.context;
    let pathDir = context.filesDir;
  }
}

// 常量定义
const API_URL = "https://ai-testing.gitee.com/v1/async/documents/parse"
const API_TOKEN = "S3CAV6E1FGMSYWWBTQNGVCNSMXP81HXSMCIBSQ7F"

@Entry
@Component
struct DocumentParser {
  @State result: string = '等待解析结果...'
  @State fileUri: string = ''
  @State fileName: string = ''
  @State isLoading: boolean = false
  @State uploadProgress: number = 0

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader()

      Scroll() {
        Column() {
          // 文件上传区域
          this.buildUploadArea()

          // 结果显示区域
          this.buildResultArea()
        }
        .padding(20)
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildHeader() {
    Row() {
      Button('←')
        .width(50)
        .height(36)
        .fontSize(18)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.9)')
        .borderRadius(18)
        .onClick(() => {
          router.back()
        })

      Text('文档解析助手')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontColor('#1A1A1A')

      Text('AI')
        .onClick(() => {
          router.back()
        })
        .fontSize(12)
        .fontColor('#007AFF')
        .backgroundColor('rgba(0, 122, 255, 0.1)')
        .padding({
          left: 8,
          right: 8,
          top: 4,
          bottom: 4
        })
        .borderRadius(10)
        .border({ width: 1, color: '#007AFF' })

    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10 })
    .backgroundColor(Color.White)
    .border({ width: { bottom: 1 }, color: 'rgba(0, 0, 0, 0.1)' })
  }

  @Builder
  buildUploadArea() {
    Column() {
      // 上传提示图标
      Text('📄')
        .fontSize(48)
        .margin({ bottom: 16 })

      Text('支持上传各种文档格式')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 8 })

      Text('PDF、Word、Excel、PPT、TXT等')
        .fontSize(12)
        .fontColor('#999999')
        .margin({ bottom: 24 })

      // 文件信息显示
      if (this.fileName) {
        Row() {
          Text('📄')
            .fontSize(16)
            .margin({ right: 8 })

          Text(this.fileName)
            .fontSize(14)
            .fontColor('#333333')
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text('✓')
            .fontSize(16)
            .fontColor('#00C853')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F0F9FF')
        .borderRadius(8)
        .border({ width: 1, color: '#B3E5FC' })
        .margin({ bottom: 16 })
      }

      // 上传按钮
      Button(this.isLoading ? '解析中...' : '选择文档')
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.isLoading ? '#CCCCCC' : '#007AFF')
        .fontColor(Color.White)
        .borderRadius(24)
        .enabled(!this.isLoading)
        .onClick(() => {
          this.selectFile()
        })

      // 进度条
      if (this.isLoading) {
        Column() {
          Progress({ value: this.uploadProgress, total: 100, type: ProgressType.Linear })
            .width('100%')
            .height(4)
            .backgroundColor('#E0E0E0')
            .style({ strokeWidth: 4 })
            .margin({ top: 16, bottom: 8 })

          Text(`解析进度: ${this.uploadProgress}%`)
            .fontSize(12)
            .fontColor('#666666')
        }
        .width('100%')
      }
    }
    .width('100%')
    .padding(24)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .border({ width: 1, color: 'rgba(0, 0, 0, 0.1)' })
    .margin({ bottom: 20 })
  }

  @Builder
  buildResultArea() {
    Column() {
      Row() {
        Text('解析结果')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Blank()

        if (this.result !== '等待解析结果...' && !this.isLoading) {
          Button('复制')
            .fontSize(12)
            .backgroundColor('rgba(0, 122, 255, 0.1)')
            .fontColor('#007AFF')
            .borderRadius(12)
            .padding({
              left: 12,
              right: 12,
              top: 6,
              bottom: 6
            })
            .onClick(() => {
              this.copyResult()
            })
        }
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 结果显示区域
      Scroll() {
        Text(this.result)
          .fontSize(14)
          .fontColor('#333333')
          .lineHeight(20)
          .width('100%')
          .padding(16)
          .backgroundColor('#F8F9FA')
          .borderRadius(8)
          .border({ width: 1, color: 'rgba(0, 0, 0, 0.1)' })
      }
      .width('100%')
      .height(300)
      .scrollBarColor('#CCCCCC')
      .scrollBarWidth(4)
    }
    .width('100%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .border({ width: 1, color: 'rgba(0, 0, 0, 0.1)' })
    .alignItems(HorizontalAlign.Start)
  }

  // 复制结果到剪贴板
  private copyResult(): void {
    try {
      // 添加复制到剪贴板的逻辑
      const pasteData = pasteboard.createPlainTextData(this.result);
      pasteboard.getSystemPasteboard();

      // 显示成功提示
      promptAction.showToast({
        message: '内容已复制到剪贴板',
        duration: 1500
      })
    } catch (error) {
      console.error('复制到剪贴板失败:', error)
      promptAction.showToast({
        message: '复制失败，请重试',
        duration: 2000
      })
    }
  }

  // 文件选择器 - 修正版本
  private selectFile(): void {
    try {
      const documentPicker = new picker.DocumentViewPicker()

      documentPicker.select()
        .then((uris: Array<string>) => {
          if (uris && uris.length > 0) {
            this.fileUri = uris[0]
            this.fileName = this.extractFileName(this.fileUri)
            console.info('fileName: ' + this.fileUri)
            console.info('fileName: ' + this.fileName)
            console.log('文件 URI:', this.fileUri);
            promptAction.showToast({
              message: '文件选择成功',
              duration: 1500
            })

            // 自动开始解析
            this.parseDocument()
          }
        })
        .catch((err: BusinessError) => {
          console.error('文件选择失败:', err)
          promptAction.showToast({
            message: '文件选择失败',
            duration: 2000
          })
        })
    } catch (error) {
      console.error('文件选择器初始化失败:', error)
      promptAction.showToast({
        message: '文件选择器初始化失败',
        duration: 2000
      })
    }
  }

  // 提取文件名 - 改进版本
  private extractFileName(uri: string): string {
    // 处理不同格式的URI
    let cleanUri = uri;

    // 移除file://前缀(如果存在)
    if (cleanUri.startsWith('file://')) {
      cleanUri = cleanUri.substring(7);
    }

    // 尝试从URI中提取文件名
    const parts = cleanUri.split('/');
    let fileName = parts[parts.length - 1] || '未知文件';

    // 处理可能的URL参数
    if (fileName.includes('?')) {
      fileName = fileName.split('?')[0];
    }

    // 处理可能的编码字符
    try {
      fileName = decodeURIComponent(fileName);
    } catch (e) {
      // 如果解码失败，使用原始文件名
    }

    return fileName;
  }

  // 文档解析逻辑 - 主要修改点
  private async parseDocument(): Promise<void> {
    if (!this.fileUri) {
      promptAction.showToast({
        message: '请先选择文件',
        duration: 2000
      })
      return
    }

    this.isLoading = true
    this.result = '正在读取文件...'
    this.uploadProgress = 20

    try {
      console.log('尝试打开文件:', this.fileUri);

      // 使用鸿蒙系统的文件API读取文件
      const fileData = await this.readFileContent(this.fileUri);
      console.log('文件读取成功，大小:', fileData.byteLength);

      this.result = '正在上传文件...'
      this.uploadProgress = 50

      // 创建HTTP请求
      const httpRequest = http.createHttp()

      httpRequest.request(API_URL, {
        method: http.RequestMethod.POST,
        header: {
          'Authorization': `Bearer ${API_TOKEN}`,
          'Content-Type': 'application/octet-stream',
          'Accept': 'application/json'
        },
        extraData: fileData,
        connectTimeout: 30000,
        readTimeout: 30000
      })
        .then((response: http.HttpResponse) => {
          this.uploadProgress = 100

          if (response.responseCode === 200) {
            try {
              let responseData: Record<string, Object> = {}

              if (typeof response.result === 'string') {
                responseData = JSON.parse(response.result) as Record<string, Object>
              } else if (response.result) {
                responseData = response.result as Record<string, Object>
              }

              if (responseData['content']) {
                this.result = responseData['content'] as string
              } else if (responseData['text']) {
                this.result = responseData['text'] as string
              } else {
                this.result = '解析结果：\n' + JSON.stringify(responseData, null, 2)
              }

              promptAction.showToast({
                message: '文档解析成功',
                duration: 2000
              })

            } catch (parseError) {
              this.result = '解析结果：\n' + (response.result?.toString() || '解析完成，但结果格式异常')
            }
          } else {
            this.result = `解析失败：HTTP ${response.responseCode}\n${response.result?.toString() || '未知错误'}`

            promptAction.showToast({
              message: '文档解析失败',
              duration: 2000
            })
          }
        })
        .catch((error: BusinessError) => {
          let errorMessage = '未知网络错误';
          if (error.code) {
            switch (error.code) {
              case 400:
                errorMessage = '请求参数错误，请检查请求数据';
                break;
              case 401:
                errorMessage = '未授权，请检查 API 密钥';
                break;
              case 404:
                errorMessage = '请求的资源不存在';
                break;
              case 500:
                errorMessage = '服务器内部错误，请稍后重试';
                break;
            }
          }
          console.error('网络请求失败:', error);
          this.result = `网络请求失败：${errorMessage}\n请检查网络连接和 API 服务状态`;

          promptAction.showToast({
            message: '网络请求失败',
            duration: 2000
          });
        })
        .finally(() => {
          this.isLoading = false
          httpRequest.destroy()
        })

    } catch (fileError) {
      console.error('文件读取失败:', fileError)
      // 提供更详细的错误信息
      this.result =
        `文件读取失败：${(fileError as BusinessError).message || '文件可能已损坏或格式不支持'}\nURI: ${this.fileUri}`
      this.isLoading = false

      promptAction.showToast({
        message: '文件读取失败',
        duration: 2000
      })
    }
  }

  // 使用鸿蒙系统API读取文件内容
  private async readFileContent(uri: string): Promise<ArrayBuffer> {
    return new Promise<ArrayBuffer>((resolve, reject) => {
      try {
        // 移除file://前缀
        let cleanUri = uri;
        if (cleanUri.startsWith('file://')) {
          cleanUri = cleanUri.substring(7);
        }

        // 修正：使用fs模块读取文件，而不是fileIo
        fs.readText(cleanUri, { encoding: 'binary' }, (err: Error, data: string | ArrayBuffer) => {
          if (err) {
            console.error('文件读取失败:', err);
            reject(err);
            return;
          }

          // 将数据转换为ArrayBuffer
          if (data instanceof ArrayBuffer) {
            resolve(data);
          } else if (typeof data === 'string') {
            // 将字符串转换为ArrayBuffer
            const buffer = new ArrayBuffer(data.length);
            const view = new Uint8Array(buffer);
            for (let i = 0; i < data.length; i++) {
              view[i] = data.charCodeAt(i);
            }
            resolve(buffer);
          } else {
            reject(new Error('文件数据格式不支持'));
          }
        });
      } catch (error) {
        console.error('读取文件时发生错误:', error);
        reject(error);
      }
    });
  }
}