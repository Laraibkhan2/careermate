/// The two kinds of account in CareerMate.
enum UserRole {
  seeker('I am looking for a job', 'Find jobs that match your skills and apply.'),
  employer('I am hiring', 'Post jobs and find the right people.');

  const UserRole(this.title, this.subtitle);

  final String title;
  final String subtitle;
}