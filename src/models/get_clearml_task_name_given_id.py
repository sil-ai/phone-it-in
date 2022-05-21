from clearml import Task 
from argparse import ArgumentParser

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "task_id",
        type=str,
        help="task ID to get the name of",
    )
    args = parser.parse_args()
    task = Task.get_task(task_id=args.task_id)
    print(task.name)