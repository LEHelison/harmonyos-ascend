export class eWeigherModule{
  device_id: string = ''
  shadow: shadowModule[] = []
}

class shadowModule{
  reported: reportedModule | null = null
}

class reportedModule{
  properties: propertiesModule | null = null
  event_time: string = ''
}

class propertiesModule{
  WeigherValue: number|string = ''
}