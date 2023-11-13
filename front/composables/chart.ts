import { ref } from "vue";
import type { IChartData, ITime } from "~/utils/chart";
import type { IWorkingTime } from "~/utils/workingTime";
interface IGroupedData {
  [user_id: number]: {
    [dateIndex: number]: number;
  };
}

const colors = [
  "#FF6384",
  "#36A2EB",
  "#FFCE56",
  "#AA6384",
  "#2CA21B",
  "#FD6A02",
  "#965AA2",
  "#D982B5",
  "#2C3E50",
  "#3498DB",
  "#F39C12",
  "#16A085",
  "#2980B9",
  "#D35400",
  "#8E44AD",
  "#27AE60",
  "#C0392B",
  "#7D3C98",
  "#2E4053",
  "#1ABC9C",
  "#5499C7",
  "#AF7AC5",
  "#48C9B0",
  "#A569BD",
  "#45B39D",
  "#7D3C98",
  "#D5DBDB",
  "#283747",
  "#1B4F72",
  "#641E16",
];

function formatDate(date: Date) {
  const day = date.getDay().toString().padStart(2, "0");
  const month = (date.getMonth() + 1).toString().padStart(2, "0"); // Months are zero-based
  const year = date.getFullYear();

  return `${day}/${month}/${year}`;
}

export function useFormatWorkingTimeToTime() {
  return (workingTimes: IWorkingTime[]): ITime[] => {
    return workingTimes
      .map((workingTime) => {
        // To local datetime
        const start = new Date(new Date(workingTime.start).toString());
        const end = new Date(new Date(workingTime.end).toString());

        const res = [];
        do {
          // Remove the time informations to be at 00:00:00
          const nextDay = new Date(start.toDateString());
          nextDay.setTime(nextDay.getTime() + 1000 * 3600 * 24);
          const endTime = Math.min(end.getTime(), nextDay.getTime());

          const time = {
            date: formatDate(start),
            duration: (endTime - start.getTime()) / (1000 * 3600),
            objectId: workingTime?.user_id,
          };

          res.push(time);
          start.setTime(endTime);
        } while (end.getTime() !== start.getTime());
        return res;
      })
      .flat();
  };
}

export function useFormatTeamWTToTime() {
  return (
    teamId: number,
    workingTimes: IWorkingTime[],
    average: boolean = false,
  ): ITime[] => {
    // Replace working times user id to team id since all working times are considered as a team working time
    const mergedWorkingTimes = workingTimes.map((wt) => ({
      ...wt,
      user_id: teamId,
    }));
    const times = useFormatWorkingTimeToTime()(mergedWorkingTimes);
    if (!average) return times;

    // Sum all the working times for each day
    const summedTimes = times.reduce(
      (
        accumulator: { [date: string]: { duration: number; count: number } },
        time,
      ) => {
        if (!accumulator[time.date])
          accumulator[time.date] = { duration: 0, count: 0 };

        accumulator[time.date].duration += time.duration;
        accumulator[time.date].count++;
        return accumulator;
      },
      {},
    );

    // Make the average returning a single ITime object for each different day worked
    // Average time is the average of the working users (absent users are not considered in the average)
    return Object.keys(summedTimes).map((key: string): ITime => {
      let duration = summedTimes[key].duration;
      if (summedTimes[key].count > 0) duration /= summedTimes[key].count;

      return {
        date: key,
        duration,
        objectId: teamId,
      };
    });
  };
}

export function useFormatChartDataWorkingTime(
  byDays: boolean = false,
  reverseDatesOrder: boolean = false,
) {
  return (chartLabels: IChartLabel[], times: ITime[]): IChartData => {
    const dateSet = new Set(
      times.map((time) => {
        return time.date;
      }),
    );
    const uniqueDates = ref<string[]>([]);
    uniqueDates.value = [...dateSet];
    uniqueDates.value.sort();
    if (reverseDatesOrder) uniqueDates.value.reverse();

    if (!byDays) {
      const labels = ref<{ [objectId: number]: string }>({});
      chartLabels.forEach((cL) => {
        labels.value[cL.id] = cL.name;
      });

      const groupedData = times.reduce((acc: IGroupedData, time: ITime) => {
        const dateIndex = uniqueDates.value.indexOf(time.date);

        if (!acc[time.objectId])
          acc[time.objectId] = Array(uniqueDates.value.length).fill(0);

        acc[time.objectId][dateIndex] += time.duration;

        return acc;
      }, {});

      const datasets = Object.keys(groupedData).map((objectId, index) => ({
        label: labels.value[objectId as any] ?? "Unknown",
        data: groupedData[objectId as any],
        backgroundColor: colors[index % colors.length],
        borderColor: colors[index % colors.length],
        fill: false,
        tension: 0.5,
      }));

      return {
        labels: uniqueDates.value,
        datasets: datasets as any,
      };
    } else {
      const idToIndex = ref<{ [objectId: number]: number }>({});
      const teamColors = ref<string[]>([]);

      chartLabels.forEach((cL, index) => {
        idToIndex.value[cL.id] = index;
        teamColors.value[index] = colors[index % colors.length];
      });

      const groupedData = times.reduce(
        (accumulator: { [date: string]: number[] }, time: ITime) => {
          if (!accumulator[time.date])
            accumulator[time.date] = Array(chartLabels.length).fill(0);

          accumulator[time.date][idToIndex.value[time.objectId]] +=
            time.duration;
          return accumulator;
        },
        {},
      );

      const datasetsbydate = uniqueDates.value.map((date) => ({
        label: date,
        data: groupedData[date],
        backgroundColor: teamColors.value,
        fill: false,
        tension: 0.5,
      }));

      return {
        labels: chartLabels.map((label) => {
          return label.name;
        }),
        datasets: datasetsbydate as any,
      };
    }
  };
}
