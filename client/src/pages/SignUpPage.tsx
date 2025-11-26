function SignUpPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-rose-50 via-background to-amber-50 px-4 py-12">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center space-y-2">
          <a href="/" className="inline-block">
            <h1 className="text-4xl font-bold text-foreground hover:text-primary transition-colors">
              Honey-Do
            </h1>
          </a>
          <p className="text-muted-foreground">
            Create your account and start organizing together
          </p>
        </div>
        SignUp Page
        <p className="text-center text-sm text-muted-foreground">
          Already have an account?{" "}
          <a
            href="/signin"
            className="font-medium text-primary hover:underline"
          >
            Sign in
          </a>
        </p>
      </div>
    </div>
  );
}

export { SignUpPage };
