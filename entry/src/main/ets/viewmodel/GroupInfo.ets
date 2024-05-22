export default class GroupInfo<TYPE, ELEMENT> {
  type: TYPE
  items: ELEMENT[]

  constructor(type: TYPE, items: ELEMENT[]) {
    this.type = type
    this.items = items
  }
}