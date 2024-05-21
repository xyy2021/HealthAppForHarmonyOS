import router from '@ohos.router'
import { CommonConstants } from '../common/constants/CommonConstants'
import ItemCard from '../view/Item/ItemCard'
import ItemList from '../view/Item/ItemList'
import ItemPanelHeader from '../view/Item/ItemPanelHeader'
import NumberKeyboard from '../view/Item/NumberKeyboard'
import RecordItem from '../viewmodel/RecordItem'

@Entry
@Component
struct ItemIndex {
  @State showPanel: boolean = false
  @State amount: number = 1
  @State value: string = ''
  @State item: RecordItem = null

  onPanelShow(item: RecordItem) {
    this.amount = 1
    this.value = ''
    this.showPanel = true
    this.item = item
  }

  build() {
    Column() {
      // 1.头部导航
      this.Header()
      // 2.列表
      ItemList({ showPanel: this.onPanelShow.bind(this) })
        .layoutWeight(1)
      // 3. 底部面板
      Panel(this.showPanel) {

        //1
        ItemPanelHeader()
        //2
        if (this.item) {
          ItemCard({ amount: this.amount, item: $item })
        }
        //3
        NumberKeyboard({ amount: $amount, value: $value })
        //4
        Row({ space: CommonConstants.SPACE_10 }) {
          Button('取消')
            .width(120)
            .backgroundColor($r('app.color.light_gray'))
            .type(ButtonType.Normal)
            .borderRadius(6)
            .onClick(() => this.showPanel = false)
          Button('提交')
            .width(120)
            .backgroundColor($r('app.color.primary_color'))
            .type(ButtonType.Normal)
            .borderRadius(6)
            .onClick(() => this.showPanel = false)
        }
        .margin({ top: 10 })

      }
      .mode(PanelMode.Full)
      .dragBar(false)
      .backgroundMask($r('app.color.light_gray'))
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  Header() {
    Row() {
      Image($r('app.media.ic_public_back'))
        .width(24)
        .onClick(() => router.back())
      Blank()
      Text('早餐').fontSize(18).fontWeight(CommonConstants.FONT_WEIGHT_600)
    }
    .width(CommonConstants.THOUSANDTH_940)
    .height(32)
  }
}