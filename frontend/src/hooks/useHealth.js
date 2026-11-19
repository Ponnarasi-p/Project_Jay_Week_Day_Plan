import { useCallback, useEffect, useState } from 'react';
import { healthService } from '../services/health.service.js';

// Loads the API/database status and lets the page check again.
export function useHealth() {
  const [health, setHealth] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      setHealth(await healthService.getHealth());
    } catch (err) {
      setHealth(null);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { health, error, loading, refresh };
}
