import { Link, useParams } from 'react-router';
import { useQueryClient } from '@tanstack/react-query';
import { ArrowLeft } from 'lucide-react';
import { useTask } from '../hooks/useTasks';
import { StatusBadge } from '../components/StatusBadge';
import { LoadingSpinner } from '../components/LoadingSpinner';
import { formatRelativeTime } from '../lib/formatRelativeTime';
import type { ListTasksResponse, Task } from '../types';

const dateFormatter = new Intl.DateTimeFormat('en-US', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
});

function isValidTask(data: unknown): data is Task {
  return (
    typeof data === 'object' &&
    data !== null &&
    typeof (data as Task).taskId === 'string' &&
    typeof (data as Task).name === 'string'
  );
}

export function TaskDetailPage() {
  const { id } = useParams<{ id: string }>();
  const queryClient = useQueryClient();

  const cachedTask = id
    ? queryClient
        .getQueryData<ListTasksResponse>(['tasks'])
        ?.tasks?.find((t) => t.taskId === id)
    : undefined;

  const { data: task, isLoading, isError } = useTask(id ?? '', cachedTask);

  if (!id) {
    return (
      <div className="bg-cream min-h-screen">
        <div className="max-w-2xl mx-auto px-4 py-8">
          <BackLink />
          <p className="text-cocoa-500 mt-6">Task not found.</p>
        </div>
      </div>
    );
  }

  if (isLoading && !task) {
    return (
      <div className="bg-cream min-h-screen">
        <div className="max-w-2xl mx-auto px-4 py-8">
          <BackLink />
          <div className="flex justify-center mt-12" aria-busy="true" aria-live="polite">
            <LoadingSpinner size="lg" />
          </div>
        </div>
      </div>
    );
  }

  if (isError || !isValidTask(task)) {
    return (
      <div className="bg-cream min-h-screen">
        <div className="max-w-2xl mx-auto px-4 py-8">
          <BackLink />
          <p className="text-cocoa-400 mt-6">Task details coming soon.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-cream min-h-screen">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <BackLink />

        <div className="bg-white rounded-2xl shadow-sm border border-cocoa-100 p-6 mt-6">
          <div className="flex items-start justify-between gap-4">
            <h1 className="text-2xl font-bold text-cocoa-900">{task.name}</h1>
            <StatusBadge status={task.status} />
          </div>

          <dl className="mt-6 space-y-4 text-sm text-cocoa-600">
            <div>
              <dt className="font-medium text-cocoa-500">Created by</dt>
              <dd className="mt-1">{task.createdBy}</dd>
            </div>

            {task.createdAt && (
              <div>
                <dt className="font-medium text-cocoa-500">Created at</dt>
                <dd className="mt-1">
                  {dateFormatter.format(new Date(task.createdAt))}{' '}
                  <span className="text-cocoa-400">
                    ({formatRelativeTime(task.createdAt)})
                  </span>
                </dd>
              </div>
            )}
          </dl>
        </div>
      </div>
    </div>
  );
}

function BackLink() {
  return (
    <Link
      to="/"
      className="inline-flex items-center gap-1.5 text-cocoa-500 hover:text-cocoa-700 transition-colors"
      aria-label="Back to task list"
    >
      <ArrowLeft className="h-4 w-4" />
      <span>Back</span>
    </Link>
  );
}
