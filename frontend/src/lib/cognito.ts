import {
  CognitoUserPool,
  CognitoUser as CognitoUserLib,
  AuthenticationDetails,
  CognitoUserSession,
} from 'amazon-cognito-identity-js';
import type { CognitoUser } from '../types';

let cachedPool: CognitoUserPool | null = null;

function getUserPool(): CognitoUserPool | null {
  if (cachedPool) return cachedPool;

  const userPoolId = import.meta.env.VITE_COGNITO_USER_POOL_ID;
  const clientId = import.meta.env.VITE_COGNITO_CLIENT_ID;

  if (!userPoolId || !clientId) return null;

  cachedPool = new CognitoUserPool({
    UserPoolId: userPoolId,
    ClientId: clientId,
  });

  return cachedPool;
}

export const cognitoErrorMessages: Record<string, string> = {
  UserNotFoundException: 'No account found with this email.',
  NotAuthorizedException: 'Incorrect email or password.',
  LimitExceededException: 'Too many attempts. Please try again later.',
  UserNotConfirmedException: 'Please verify your email before signing in.',
};

function mapCognitoError(err: unknown): string {
  if (err && typeof err === 'object' && 'name' in err) {
    const name = (err as { name: string }).name;
    return cognitoErrorMessages[name] ?? 'An unexpected error occurred. Please try again.';
  }
  return 'An unexpected error occurred. Please try again.';
}

function extractUser(session: CognitoUserSession): CognitoUser {
  const idToken = session.getIdToken();
  const payload = idToken.decodePayload();
  return {
    sub: payload['sub'] as string,
    email: payload['email'] as string,
    idToken: idToken.getJwtToken(),
  };
}

export function signIn(email: string, password: string): Promise<CognitoUser> {
  const pool = getUserPool();
  if (!pool) {
    return Promise.reject(
      new Error('Cognito is not configured. Set VITE_COGNITO_USER_POOL_ID and VITE_COGNITO_CLIENT_ID.'),
    );
  }

  return new Promise((resolve, reject) => {
    const cognitoUser = new CognitoUserLib({
      Username: email,
      Pool: pool,
    });

    const authDetails = new AuthenticationDetails({
      Username: email,
      Password: password,
    });

    cognitoUser.authenticateUser(authDetails, {
      onSuccess: (session) => {
        resolve(extractUser(session));
      },
      onFailure: (err: unknown) => {
        reject(new Error(mapCognitoError(err)));
      },
    });
  });
}

export function signOut(): void {
  const pool = getUserPool();
  if (!pool) return;

  const cognitoUser = pool.getCurrentUser();
  if (cognitoUser) {
    cognitoUser.signOut();
  }
}

export function getCurrentSession(): Promise<CognitoUser | null> {
  const pool = getUserPool();
  if (!pool) return Promise.resolve(null);

  return new Promise((resolve) => {
    const cognitoUser = pool.getCurrentUser();
    if (!cognitoUser) {
      resolve(null);
      return;
    }

    cognitoUser.getSession((err: Error | null, session: CognitoUserSession | null) => {
      if (err || !session || !session.isValid()) {
        resolve(null);
        return;
      }
      resolve(extractUser(session));
    });
  });
}

export function getCurrentUser(): CognitoUserLib | null {
  const pool = getUserPool();
  if (!pool) return null;
  return pool.getCurrentUser();
}
