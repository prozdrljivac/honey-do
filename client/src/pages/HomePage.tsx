function HomePage() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-rose-50 via-background to-amber-50">
      <div className="max-w-2xl mx-auto px-6 text-center space-y-8">
        <div className="space-y-4">
          <h1 className="text-5xl md:text-6xl font-bold text-balance text-foreground">
            Honey-Do
          </h1>
          <p className="text-xl text-muted-foreground text-balance">
            The simple task manager for couples. Create tasks for each other,
            stay organized together.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <button>
            <a href="/signin">Sign In</a>
          </button>
          <button className="text-lg bg-transparent">
            <a href="/signup">Create Account</a>
          </button>
        </div>

        <div className="pt-8 text-sm text-muted-foreground">
          <p>Built for partners who tackle life together</p>
        </div>
      </div>
    </div>
  );
}

export { HomePage };
