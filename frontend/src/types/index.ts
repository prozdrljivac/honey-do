/** Fields sent in the POST /tasks request body */
export interface CreateTaskBody {
  name: string;
  status: string;
  createdBy: string;
}

/** Shape returned by POST /tasks */
export interface CreateTaskResponse {
  message?: string;
  taskId?: string;
  error?: string;
}

/** A single task as returned by GET /tasks */
export interface Task {
  taskId: string;
  name: string;
  status: string;
  createdBy: string;
  createdAt: string; // ISO 8601 (RFC 3339)
}

/** Shape returned by GET /tasks */
export interface ListTasksResponse {
  tasks?: Task[];
  error?: string;
}

/** Auth state managed by AuthContext */
export interface AuthState {
  isAuthenticated: boolean;
  isLoading: boolean;
  user: CognitoUser | null;
  email: string | null;
}

export type AuthAction =
  | { type: 'LOADING' }
  | { type: 'SIGNED_IN'; user: CognitoUser; email: string }
  | { type: 'SIGNED_OUT' }
  | { type: 'ERROR' };

export interface CognitoUser {
  sub: string;
  email: string;
  idToken: string;
}
