'use client';

import { clsx, type ClassValue } from 'clsx';
import { Loader2, X } from 'lucide-react';
import { forwardRef, ReactNode, useEffect } from 'react';
import { twMerge } from 'tailwind-merge';

export const cn = (...v: ClassValue[]) => twMerge(clsx(v));

// ------------------------------------------------------------------ Bouton
type Variant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger' | 'success';
const variants: Record<Variant, string> = {
  primary: 'bg-primary text-white hover:bg-primary/90',
  secondary: 'bg-gold text-primary-dark hover:bg-gold/90',
  outline: 'border border-border bg-surface hover:bg-muted',
  ghost: 'hover:bg-muted',
  danger: 'bg-danger text-white hover:bg-danger/90',
  success: 'bg-success text-white hover:bg-success/90',
};

export const Button = forwardRef<HTMLButtonElement, React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant; loading?: boolean; size?: 'sm' | 'md' }>(
  ({ className, variant = 'primary', loading, size = 'md', children, disabled, ...props }, ref) => (
    <button
      ref={ref}
      disabled={disabled || loading}
      className={cn(
        'inline-flex items-center justify-center gap-2 rounded-lg font-medium transition-colors disabled:opacity-50 disabled:pointer-events-none focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary',
        size === 'sm' ? 'h-8 px-3 text-sm' : 'h-10 px-4 text-sm',
        variants[variant],
        className,
      )}
      {...props}
    >
      {loading && <Loader2 className="h-4 w-4 animate-spin" aria-hidden />}
      {children}
    </button>
  ),
);
Button.displayName = 'Button';

// ------------------------------------------------------------------ Champs
export const Input = forwardRef<HTMLInputElement, React.InputHTMLAttributes<HTMLInputElement>>(({ className, ...props }, ref) => (
  <input
    ref={ref}
    className={cn('h-10 w-full rounded-lg border border-border bg-surface px-3 text-sm placeholder:text-subtle focus:outline-none focus:ring-2 focus:ring-primary/40', className)}
    {...props}
  />
));
Input.displayName = 'Input';

export const Textarea = forwardRef<HTMLTextAreaElement, React.TextareaHTMLAttributes<HTMLTextAreaElement>>(({ className, ...props }, ref) => (
  <textarea ref={ref} className={cn('w-full rounded-lg border border-border bg-surface p-3 text-sm focus:outline-none focus:ring-2 focus:ring-primary/40', className)} {...props} />
));
Textarea.displayName = 'Textarea';

export const Select = forwardRef<HTMLSelectElement, React.SelectHTMLAttributes<HTMLSelectElement>>(({ className, children, ...props }, ref) => (
  <select ref={ref} className={cn('h-10 w-full rounded-lg border border-border bg-surface px-3 text-sm focus:outline-none focus:ring-2 focus:ring-primary/40', className)} {...props}>
    {children}
  </select>
));
Select.displayName = 'Select';

export function Field({ label, children, hint }: { label: string; children: ReactNode; hint?: string }) {
  return (
    <label className="block space-y-1.5">
      <span className="text-sm font-medium">{label}</span>
      {children}
      {hint && <span className="block text-xs text-subtle">{hint}</span>}
    </label>
  );
}

// ------------------------------------------------------------------ Conteneurs
export function Card({ className, children }: { className?: string; children: ReactNode }) {
  return <div className={cn('rounded-xl border border-border bg-surface shadow-sm', className)}>{children}</div>;
}

export function CardHeader({ title, description, action }: { title: string; description?: string; action?: ReactNode }) {
  return (
    <div className="flex items-start justify-between gap-4 border-b border-border px-5 py-4">
      <div>
        <h2 className="font-semibold">{title}</h2>
        {description && <p className="mt-0.5 text-sm text-subtle">{description}</p>}
      </div>
      {action}
    </div>
  );
}

export function PageHeader({ title, description, action }: { title: string; description?: string; action?: ReactNode }) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">{title}</h1>
        {description && <p className="mt-1 text-sm text-subtle">{description}</p>}
      </div>
      {action}
    </div>
  );
}

// ------------------------------------------------------------------ Badge de statut (couleurs sémantiques)
const tone = (s: string) => {
  if (/^(PAYE|VALIDE|PUBLIE|ACTIVE|RESOLU|CLOTURE|PRETE|LIVREE|ACCEPTEE|CONFIRME|PRESENT)$/.test(s)) return 'bg-success/12 text-success';
  if (/^(EN_RETARD|ECHOUE|REJETE|REJETEE|REFUSEE|ANNULE|SUSPENDED|ABSENT)$/.test(s)) return 'bg-danger/12 text-danger';
  if (/^(A_PAYER|PARTIELLEMENT_PAYE|EN_ATTENTE|SOUMISE|EN_TRAITEMENT|OUVERT|EN_COURS|BROUILLON|PENDING_ACTIVATION|RETARD|OUVERTE|EN_EXAMEN)$/.test(s))
    return 'bg-warning/15 text-warning';
  return 'bg-info/12 text-info';
};

export function Badge({ status, children }: { status: string; children?: ReactNode }) {
  return <span className={cn('inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold', tone(status))}>{children ?? status.replace(/_/g, ' ').toLowerCase()}</span>;
}

// ------------------------------------------------------------------ Tableau
export function Table({ head, children, empty }: { head: ReactNode[]; children: ReactNode; empty?: boolean }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead className="bg-muted text-left text-xs uppercase tracking-wide text-subtle">
          <tr>{head.map((h, i) => <th key={i} className="px-4 py-3 font-semibold">{h}</th>)}</tr>
        </thead>
        <tbody className="divide-y divide-border">{children}</tbody>
      </table>
      {empty && <p className="py-12 text-center text-sm text-subtle">Aucun élément</p>}
    </div>
  );
}

export const Td = ({ children, className }: { children: ReactNode; className?: string }) => <td className={cn('px-4 py-3 align-middle', className)}>{children}</td>;

// ------------------------------------------------------------------ États
export function Loading() {
  return (
    <div className="flex items-center justify-center py-16 text-subtle" role="status">
      <Loader2 className="mr-2 h-5 w-5 animate-spin" /> Chargement…
    </div>
  );
}

export function ErrorBox({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  return (
    <div className="rounded-xl border border-danger/30 bg-danger/5 p-5 text-sm text-danger" role="alert">
      {(error as Error)?.message ?? 'Erreur inattendue'}
      {onRetry && (
        <Button variant="outline" size="sm" className="ml-4" onClick={onRetry}>
          Réessayer
        </Button>
      )}
    </div>
  );
}

// ------------------------------------------------------------------ Fenêtre modale
export function Modal({ open, onClose, title, children, wide }: { open: boolean; onClose: () => void; title: string; children: ReactNode; wide?: boolean }) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose();
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);
  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4" onClick={onClose}>
      <div role="dialog" aria-modal aria-label={title} className={cn('max-h-[90vh] w-full overflow-y-auto rounded-xl bg-surface shadow-xl', wide ? 'max-w-3xl' : 'max-w-lg')} onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between border-b border-border px-5 py-4">
          <h3 className="font-semibold">{title}</h3>
          <button onClick={onClose} aria-label="Fermer" className="rounded p-1 hover:bg-muted">
            <X className="h-4 w-4" />
          </button>
        </div>
        <div className="p-5">{children}</div>
      </div>
    </div>
  );
}

export function Stat({ label, value, hint, accent }: { label: string; value: ReactNode; hint?: string; accent?: string }) {
  return (
    <Card className="p-5">
      <p className="text-sm text-subtle">{label}</p>
      <p className={cn('mt-1 text-2xl font-bold', accent)}>{value}</p>
      {hint && <p className="mt-1 text-xs text-subtle">{hint}</p>}
    </Card>
  );
}
