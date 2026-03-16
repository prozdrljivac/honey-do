import { createContext, useCallback, useEffect, useReducer } from 'react';
import type { ReactNode } from 'react';
import type { AuthState, AuthAction, CognitoUser } from '../types';
import * as cognito from '../lib/cognito';
import { NewPasswordRequiredError } from '../lib/cognito';

interface AuthContextValue {
  state: AuthState;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => void;
  setSignedIn: (user: CognitoUser) => void;
}

const initialState: AuthState = {
  isAuthenticated: false,
  isLoading: true,
  user: null,
  email: null,
};

function authReducer(state: AuthState, action: AuthAction): AuthState {
  switch (action.type) {
    case 'LOADING':
      return { ...state, isLoading: true };
    case 'SIGNED_IN':
      return {
        isAuthenticated: true,
        isLoading: false,
        user: action.user,
        email: action.email,
      };
    case 'SIGNED_OUT':
      return { isAuthenticated: false, isLoading: false, user: null, email: null };
    case 'ERROR':
      return { isAuthenticated: false, isLoading: false, user: null, email: null };
  }
}

export const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(authReducer, initialState);

  useEffect(() => {
    cognito.getCurrentSession().then((user: CognitoUser | null) => {
      if (user) {
        dispatch({ type: 'SIGNED_IN', user, email: user.email });
      } else {
        dispatch({ type: 'SIGNED_OUT' });
      }
    });
  }, []);

  const handleSignIn = useCallback(async (email: string, password: string) => {
    dispatch({ type: 'LOADING' });
    try {
      const result = await cognito.signIn(email, password);
      if (result.status === 'SUCCESS') {
        dispatch({ type: 'SIGNED_IN', user: result.user, email: result.user.email });
      } else {
        dispatch({ type: 'SIGNED_OUT' });
        throw new NewPasswordRequiredError(result.cognitoUser);
      }
    } catch (err) {
      if (err instanceof NewPasswordRequiredError) {
        throw err;
      }
      dispatch({ type: 'ERROR' });
      throw err;
    }
  }, []);

  const setSignedIn = useCallback((user: CognitoUser) => {
    dispatch({ type: 'SIGNED_IN', user, email: user.email });
  }, []);

  const handleSignOut = useCallback(() => {
    cognito.signOut();
    dispatch({ type: 'SIGNED_OUT' });
  }, []);

  return (
    <AuthContext value={{ state, signIn: handleSignIn, signOut: handleSignOut, setSignedIn }}>
      {children}
    </AuthContext>
  );
}
