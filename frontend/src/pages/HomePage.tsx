import { useState } from 'react';
import { ClipboardList } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';
import { useListTasks } from '../hooks/useTasks';
import { Button } from '../components/Button';
import { Modal } from '../components/Modal';
import { LoadingSpinner } from '../components/LoadingSpinner';
import { TaskCard } from '../components/TaskCard';
import { TaskCreateForm } from '../components/TaskCreateForm';

export function HomePage() {
  const { email, signOut } = useAuth();
  const { data, isLoading } = useListTasks();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const tasks = [...(data?.tasks ?? [])].sort(
    (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
  );

  return (
    <div className="bg-cream min-h-screen">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <header className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-2xl font-bold text-cocoa-900">HoneyDo</h1>
            <p className="text-sm text-cocoa-500">{email}</p>
          </div>
          <Button variant="secondary" onClick={signOut}>
            Sign Out
          </Button>
        </header>

        <div className="mb-6">
          <Button onClick={() => setIsModalOpen(true)}>Add Task</Button>
        </div>

        {isLoading ? (
          <div className="flex justify-center py-12" aria-busy="true" aria-live="polite">
            <LoadingSpinner size="lg" />
          </div>
        ) : tasks.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-cocoa-400">
            <ClipboardList className="h-12 w-12 mb-4" />
            <p className="text-lg">No tasks yet! Add one to get started.</p>
          </div>
        ) : (
          <div className="flex flex-col gap-4">
            {tasks.map((task) => (
              <TaskCard key={task.taskId} task={task} />
            ))}
          </div>
        )}

        <Modal
          isOpen={isModalOpen}
          onClose={() => setIsModalOpen(false)}
          title="New Task"
        >
          <TaskCreateForm onSuccess={() => setIsModalOpen(false)} />
        </Modal>
      </div>
    </div>
  );
}
