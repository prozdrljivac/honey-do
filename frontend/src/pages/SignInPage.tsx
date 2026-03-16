import { useState, type FormEvent } from 'react';
import type { CognitoUser as CognitoUserLib } from 'amazon-cognito-identity-js';
import { useAuth } from '../hooks/useAuth';
import { NewPasswordRequiredError, completeNewPassword } from '../lib/cognito';
import { Button } from '../components/Button';
import { Input } from '../components/Input';

export function SignInPage() {
  const { signIn, setSignedIn } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const [pendingCognitoUser, setPendingCognitoUser] = useState<CognitoUserLib | null>(null);
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      await signIn(email, password);
    } catch (err) {
      if (err instanceof NewPasswordRequiredError) {
        setPendingCognitoUser(err.cognitoUser);
      } else {
        setError(err instanceof Error ? err.message : 'An unexpected error occurred. Please try again.');
      }
    } finally {
      setIsLoading(false);
    }
  }

  async function handleNewPassword(e: FormEvent) {
    e.preventDefault();
    setError('');

    if (newPassword !== confirmPassword) {
      setError('Passwords do not match.');
      return;
    }

    if (!pendingCognitoUser) return;

    setIsLoading(true);
    try {
      const user = await completeNewPassword(pendingCognitoUser, newPassword);
      setSignedIn(user);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="bg-cream min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-md">
        <div className="bg-white rounded-2xl shadow-sm border border-cocoa-100 p-8">
          <h1 className="text-3xl font-bold text-cocoa-900 text-center mb-8">
            HoneyDo
          </h1>

          {pendingCognitoUser ? (
            <form onSubmit={handleNewPassword} aria-busy={isLoading}>
              <div className="flex flex-col gap-4">
                <p className="text-sm text-cocoa-700">
                  Please set a new password for your account.
                </p>

                <Input
                  label="New Password"
                  type="password"
                  required
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  disabled={isLoading}
                  autoComplete="new-password"
                />

                <Input
                  label="Confirm Password"
                  type="password"
                  required
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  disabled={isLoading}
                  autoComplete="new-password"
                />

                <p className="text-xs text-cocoa-500">
                  Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters.
                </p>

                {error && (
                  <p className="text-sm text-red-600" role="alert">
                    {error}
                  </p>
                )}

                <Button
                  type="submit"
                  isLoading={isLoading}
                  className="w-full mt-2"
                >
                  Set Password
                </Button>
              </div>
            </form>
          ) : (
            <form onSubmit={handleSubmit} aria-busy={isLoading}>
              <div className="flex flex-col gap-4">
                <Input
                  label="Email"
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  disabled={isLoading}
                  autoComplete="email"
                />

                <Input
                  label="Password"
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  disabled={isLoading}
                  autoComplete="current-password"
                />

                {error && (
                  <p className="text-sm text-red-600" role="alert">
                    {error}
                  </p>
                )}

                <Button
                  type="submit"
                  isLoading={isLoading}
                  className="w-full mt-2"
                >
                  Sign In
                </Button>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}
