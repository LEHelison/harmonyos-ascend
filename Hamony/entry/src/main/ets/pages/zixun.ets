import App from '@system.app';
import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export default struct zixun {
  @State message: string = 'Hello World';
  private listScroller: Scroller = new Scroller();
  @State currentTime: string = '';

  aboutToAppear() {
    this.updateTime()
    setInterval(() => {
      this.updateTime()
    }, 1000)
  }

  updateTime() {
    const now = new Date()
    const hours = now.getHours().toString().padStart(2, '0')
    const minutes = now.getMinutes().toString().padStart(2, '0')
    const month = (now.getMonth() + 1).toString().padStart(2, '0')
    const day = now.getDate().toString().padStart(2, '0')
    this.currentTime = `${month}月${day}日 ${hours}:${minutes}`
  }

  build() {
    Stack() {
      // 背景图片
      Image($r("app.media.img"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 主要内容
      Column() {
        // 顶部导航栏
        Row() {

          Text('工厂资讯')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .margin({left:30})
            .fontColor('#1A1A1A')

          Text(this.currentTime)
            .fontSize(12)
            .fontColor('#666666')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(10)
        }
        .width('100%')
        .height(60)
        .padding({ left: 20, right: 20, top: 10 })

        // 主体内容
        Scroll() {
          Column() {
            // 头部统计信息
            this.buildHeaderStats()

            // 新闻列表
            this.buildNewsList()
          }
          .padding({ left: 20, right: 20, bottom: 30 })
        }
        .layoutWeight(1)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .backdropBlur(10)
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildHeaderStats() {

  }

  @Builder
  buildStatItem(icon: string, title: string, count: string, color: string) {
    Column() {
      Text(icon)
        .fontSize(18)
        .margin({ bottom: 6 })

      Text(count)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(10)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
    }
    .width(90)
    .height(70)
    .padding(8)
    .backgroundColor('rgba(255, 255, 255, 0.6)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.05)'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildNewsList() {
    Column() {
      Text('📰 最新资讯')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 16 })

      List({ space: 12, scroller: this.listScroller }) {
        ListItem() {
          this.buildNewsItem(
            'https://mskcloud.cn/data/upload/image/20201009/20201009150217_45891.jpg',
            '2024年，全球智慧工厂市场规模预计突破千亿美元，推动制造业智能化转型。',
            '2024.12.20',
            true
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse2-mm.cn.bing.net/th/id/OIP-C.waq-280JdjKk5PkEu2nIVwHaEK?w=289&h=180&c=7&r=0&o=5&dpr=2&pid=1.7',
            '某汽车企业智慧工厂正式投产，生产效率提升30%，大幅降低生产成本。',
            '2024.12.12',
            false
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse4-mm.cn.bing.net/th/id/OIP-C.Pmpr0BljrieWuPkOJatiUQHaDQ?w=315&h=153&c=7&r=0&o=5&dpr=2&pid=1.7',
            '政府出台新政策，支持企业建设智慧工厂，提供资金补贴和技术指导。',
            '2024.12.24',
            true
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse1-mm.cn.bing.net/th/id/OIP-C.I8BNB2oSYlOP5j9Rte_o0QHaDt?w=299&h=175&c=7&r=0&o=5&dpr=2&pid=1.7',
            '智慧工厂引入AI技术，实现生产流程自主优化，产品质量大幅提升。',
            '2024.12.13',
            false
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse2-mm.cn.bing.net/th/id/OIP-C.DuAhgU8XwaFMUqDSVjsaOQHaGa?w=196&h=180&c=7&r=0&o=5&dpr=2&pid=1.7',
            '中外企业携手共建智慧工厂，推动智能制造技术全球共享。',
            '2024.12.10',
            false
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse2-mm.cn.bing.net/th/id/OIP-C.3BAp7vSYH8YQLO7-A0h7iQHaEK?w=308&h=180&c=7&r=0&o=5&dpr=2&pid=1.7',
            '智慧工厂采用绿色能源和节能技术，大幅降低碳排放，助力可持续发展。',
            '2024.12.18',
            false
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse2-mm.cn.bing.net/th/id/OIP-C.UOvwra8_BOHdUHed8MV3XAHaCF?w=309&h=98&c=7&r=0&o=5&dpr=2&pid=1.7',
            '高校开设智慧工厂专业，培养专业人才，满足制造业智能化需求。',
            '2024.12.26',
            true
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse3-mm.cn.bing.net/th/id/OIF-C.4LBr49YSeYB3OX0taVvvmQ?w=349&h=167&c=7&r=0&o=5&dpr=2&pid=1.7',
            '智慧工厂技术已广泛应用于电子、汽车、医疗等领域，推动产业升级。',
            '2024.12.12',
            false
          )
        }

        ListItem() {
          this.buildNewsItem(
            'https://tse3-mm.cn.bing.net/th/id/OIF-C.g0j9wtwPTgMmoRHDi699Lg?w=231&h=180&c=7&r=0&o=5&dpr=2&pid=1.7',
            '智慧工厂加强网络安全防护，确保生产数据安全和系统稳定运行。',
            '2024.12.26',
            false
          )
        }
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
  }

  @Builder
  buildNewsItem(imageUrl: string, title: string, date: string, isHot: boolean) {
    Row() {
      // 新闻图片
      Stack() {
        Image(imageUrl)
          .width(100)
          .height(70)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        if (isHot) {
          Text('热门')
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#FF3B30')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .borderRadius(4)
            .position({ x: 4, y: 4 })
        }
      }
      .margin({ right: 12 })

      // 新闻内容
      Column() {
        Text(title)
          .fontSize(14)
          .fontColor('#1A1A1A')
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(20)
          .margin({ bottom: 8 })

        Row() {
          Text('📖 阅读')
            .fontSize(12)
            .fontColor('#007AFF')

          Blank()

          Text(date)
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('rgba(255, 255, 255, 0.6)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.05)'
    })
    .onClick(() => {
      promptAction.showToast({
        message: '打开新闻详情',
        duration: 1500
      })
    })
  }
}