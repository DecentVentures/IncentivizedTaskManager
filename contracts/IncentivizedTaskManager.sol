pragma solidity ^0.4.17;

contract IncentivizedTaskManager {

  struct Task {
    bytes data;
    function (bytes memory) external callback;
    address taskOwner;
    address billTo;
  }

  struct IncentivizedTask {
    Task task;
    uint incentive;
  }

  struct ScheduledTask {
    uint repeatTimes;
    uint lastRun;
    uint waitTime;
    IncentivizedTask scheduled;
  }

  uint public currentGasPrice;
  ScheduledTask[] tasks;
  Worker[] workers;

  function updateManagerInfo() {
    currentGasPrice = 0;
  }

  function canRun(uint index) public view {
    return tasks[index].lastRun + waitTime < now;
  }

  function addTask(function (bytes memory) external fn, bytes params, uint repeatTimes, uint waitTime, uint incentive, address billableWallet) public {

    Task task = Task({data: params, callback: fn, taskOwner: msg.sender, billTo: billableWallet});
    IncentivizedTask it = IncentivizedTask({task: task, incentive: incentive});
    tasks.push(ScheduledTask({repeatTimes: repeatTimes, lastRun: 0, waitTime: waitTime, scheduled: it});
  }

  function getWork() public view {
    uint[] work;
    for(uint i = 0; i < tasks.length; i++) {
      if(canRun(i)) {
        work.push(i);
      }
    }
    return canRun;
  }

  function run(index) public {
    require(canRun(index));
    bool toDelete = false;
    tasks[index].lastRun = now;
    if(tasks[index].repeatTimes > 1) {
      tasks[index].repeatTimes--;
    } else if (tasks[index].repeatTimes == 1) {
      toDelete = true;
    }
    Task toRun = tasks[index];
    toRun.callback(toRun.data);
    if(toDelete) {
      tasks[index] = tasks[tasks.length -1];
      delete tasks[tasks.length -1];
    }
    msg.sender.transfer(toRun.task.incentive)
  }
}
