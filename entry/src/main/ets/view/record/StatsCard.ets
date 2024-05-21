import BreakpointType from '../../common/bean/BreakpointType'
import BreakpointConstants from '../../common/constants/BreakpointConstants'
import { CommonConstants } from '../../common/constants/CommonConstants'
import DateUtil from '../../common/utils/DateUtil'
import CaloriesStats from './CaloriesStats'
import DatePickDialog from './DatePickDialog'
import NutrientStats from './NutrientStats'


@Component
export default struct StatsCard {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM
  @StorageProp('selectedDate') selectedDate: number = DateUtil.beginTimeOfDay(new Date())
  controller: CustomDialogController = new CustomDialogController({
    builder: DatePickDialog({ selectedDate: new Date(this.selectedDate) })
  })

  build() {
    Column() {
      //1. 日期信息
      Row() {
        Text(DateUtil.formatDate(this.selectedDate))
          .fontColor($r('app.color.secondary_color'))
        Image($r('app.media.ic_public_spinner'))
          .width(20)
          .fillColor($r('app.media.ic_public_spinner'))
      }
      .padding(CommonConstants.SPACE_12)
      .onClick(() => this.controller.open())

      //2.统计信息
      Swiper() {
        //2.1 热量统计
        CaloriesStats()
        //2.2 营养素统计
        NutrientStats()
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(CommonConstants.DEFAULT_18)
      .indicatorStyle({ selectedColor: $r('app.color.primary_color') })
      .displayCount(new BreakpointType({
        sm: 1,
        md: 1,
        lg: 2
      }).getValue(this.currentBreakpoint))

    }
    .width(CommonConstants.THOUSANDTH_940)
    .backgroundColor($r('app.color.stats_title_bgc'))
    .borderRadius(CommonConstants.DEFAULT_18)
  }
}