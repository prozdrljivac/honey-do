import { BrowserRouter, Routes, Route } from 'react-router';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AuthProvider } from './context/AuthContext';
import { ProtectedRoute } from './components/ProtectedRoute';
import { PublicRoute } from './components/PublicRoute';
import { SignInPage } from './pages/SignInPage';
import { HomePage } from './pages/HomePage';
import { TaskDetailPage } from './pages/TaskDetailPage';

const queryClient = new QueryClient();

export function App() {
  return (
    <BrowserRouter>
      <QueryClientProvider client={queryClient}>
        <AuthProvider>
          <Routes>
            <Route path="/sign-in" element={<PublicRoute><SignInPage /></PublicRoute>} />
            <Route path="/" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
            <Route path="/tasks/:id" element={<ProtectedRoute><TaskDetailPage /></ProtectedRoute>} />
          </Routes>
        </AuthProvider>
      </QueryClientProvider>
    </BrowserRouter>
  );
}
