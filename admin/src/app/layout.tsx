import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'UniParent — Back-office AFRAM',
  description: 'Pilotage de la vie universitaire : finances, présences, notes, communication.',
  robots: { index: false, follow: false },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
      </head>
      <body className="min-h-screen font-sans antialiased">{children}</body>
    </html>
  );
}
