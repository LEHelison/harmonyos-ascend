export class PM2_5Module{
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
  Threshold: number|string = ''
  pm2_5_data: number|string = ''
}