import shouye from './shouye'
import jiankong from './jiankong'
import HuanJingPage from './HuanJingPage'
import yonghu from './yonghu'
import zixun from './zixun'
import damoxing from './damoxing'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  private tabsController: TabsController = new TabsController()

  @Builder TabBuilder(title: string, image: Resource, selectImage: Resource, tag: number, badgeValue: number = 0) {
    Column() {
      Badge({ count: badgeValue, style: { badgeSize: 16 } }) {
        Image(this.currentIndex == tag ? selectImage : image)
          .size({ width: 25, height: 25 })
      }
      Text(title)
        .fontColor(this.currentIndex == tag ? '#27ba9d' : '#000000')
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = tag
      this.tabsController.changeIndex(this.currentIndex)
    })
  }

  build() {
    Tabs({ controller: this.tabsController, barPosition: BarPosition.End }) {
      // 首页
      TabContent() {
        shouye()
      }
      .tabBar(this.TabBuilder('首页', $r('app.media.shouye1'), $r('app.media.shouye1'), 0, 0))

      // 大模型页面
      TabContent() {
        damoxing()
      }
      .tabBar(this.TabBuilder('大模型', $r('app.media.damoxing2'), $r('app.media.damoxing2'), 1, 0))

      // 咨询页面
      TabContent() {
        zixun()
      }
      .tabBar(this.TabBuilder('资讯', $r('app.media.tongzhi2'), $r('app.media.tongzhi2'), 2, 0))

      // 我的页面
      TabContent() {
        yonghu()
      }
      .tabBar(this.TabBuilder('我的', $r('app.media.wod'), $r('app.media.wod'), 3, 0))
    }
    .width('100%')
    .height('100%')

    .onChange(index => this.currentIndex = index)
  }
}