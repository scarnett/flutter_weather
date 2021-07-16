/**
 * The push message model
 */
export class Message {
  title: any
  body: any
  image: any
  data: any = {}
  priorityAndroid: MessagePriorityAndroid = 'high'
  priorityIos: MessagePriorityIos = '10'
  sound: MessageSound = 'default'
  color: string = '#7D33B7'
  icon: string = 'app_icon'
  tag: string = 'flutter_weather'
}

type MessageSound = 'default' | 'disabled'
type MessagePriorityAndroid = 'normal' | 'high'
type MessagePriorityIos = '5' | '10'
