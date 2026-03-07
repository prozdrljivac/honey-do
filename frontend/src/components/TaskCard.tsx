import { Link } from 'react-router';
import type { Task } from '../types';
import { StatusBadge } from './StatusBadge';
import { formatRelativeTime } from '../lib/formatRelativeTime';

interface TaskCardProps {
  task: Task;
}

export function TaskCard({ task }: TaskCardProps) {
  return (
    <Link
      to={`/tasks/${task.taskId}`}
      className="bg-white rounded-2xl shadow-sm border border-cocoa-100 p-6 hover:shadow-md transition-shadow block"
    >
      <div className="flex items-start justify-between gap-4">
        <h3 className="text-lg font-semibold text-cocoa-900">{task.name}</h3>
        <StatusBadge status={task.status} />
      </div>
      <div className="mt-3 flex items-center gap-2 text-sm text-cocoa-500">
        <span>{task.createdBy}</span>
        <span>&middot;</span>
        <span>{formatRelativeTime(task.createdAt)}</span>
      </div>
    </Link>
  );
}
