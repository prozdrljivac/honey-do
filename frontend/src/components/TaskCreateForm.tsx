import { useState, useId, type FormEvent } from 'react';
import { useCreateTask } from '../hooks/useTasks';
import { useAuth } from '../hooks/useAuth';
import { Input } from './Input';
import { Button } from './Button';

interface TaskCreateFormProps {
  onSuccess: () => void;
}

const STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'in-progress', label: 'In Progress' },
  { value: 'done', label: 'Done' },
];

export function TaskCreateForm({ onSuccess }: TaskCreateFormProps) {
  const { email } = useAuth();
  const { mutate, isPending, isError } = useCreateTask();
  const selectId = useId();

  const [name, setName] = useState('');
  const [status, setStatus] = useState('pending');
  const [createdBy, setCreatedBy] = useState(email ?? '');

  function handleSubmit(e: FormEvent) {
    e.preventDefault();
    mutate({ name, status, createdBy }, { onSuccess });
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-4">
      <Input
        label="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        required
        disabled={isPending}
      />

      <div className="flex flex-col gap-1.5">
        <label htmlFor={selectId} className="text-sm font-medium text-cocoa-700">
          Status
        </label>
        <select
          id={selectId}
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          disabled={isPending}
          className="bg-white border border-cocoa-200 focus:border-honey-500 focus:ring-2 focus:ring-honey-200 rounded-xl px-4 py-3 outline-none transition-all text-cocoa-900"
        >
          {STATUS_OPTIONS.map((opt) => (
            <option key={opt.value} value={opt.value}>
              {opt.label}
            </option>
          ))}
        </select>
      </div>

      <Input
        label="Created by"
        value={createdBy}
        onChange={(e) => setCreatedBy(e.target.value)}
        required
        disabled={isPending}
      />

      {isError && (
        <p className="text-sm text-red-600">Failed to create task. Please try again.</p>
      )}

      <Button type="submit" isLoading={isPending} disabled={isPending}>
        Create Task
      </Button>
    </form>
  );
}
