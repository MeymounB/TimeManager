export interface ITime {
  date: string;
  duration: number;
  objectId: number;
}

export interface IDataset {
  label: string;
  backgroundColor: string;
  data: { [dateIndex: number]: number };
}

export interface IChartLabel {
  id: number;
  name: string;
}

export interface IChartData {
  labels: string[];
  datasets: IDataset[];
}
