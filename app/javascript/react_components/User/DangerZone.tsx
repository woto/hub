import * as React from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import axios from '../system/Axios';
import { useToasts } from '../Toast/ToastManager';

type DangerZoneType = {defaultValues: any}

export default function DangerZone({
  isLoading, defaultValues, isFetching,
}: DangerZoneType) {
  return (
    <div className="tw-mt-6">Danger zone</div>
  );
}
