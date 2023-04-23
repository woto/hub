import * as React from 'react';
import { useCallback } from 'react';
import MentionsCore from '../Mentions/MentionsCore';
import axios from '../system/Axios';
import { MentionResponse } from '../system/TypeScript';

export default function Mentions(
  {
    listing_id,
  }: {
    listing_id: number,
  },
) {
  const fetchFunction = useCallback(({
    entityIds, searchString, sort, pageParam,
  }: { entityIds?: any[], searchString?: string, sort?: string, pageParam?: number, listingId?: number }) => axios.post<MentionResponse>('/api/mentions', {
    page: pageParam,
    entity_ids: entityIds,
    q: searchString,
    sort,
  }), []);

  return (
    <MentionsCore listingId={listing_id} fetchFunction={fetchFunction} />
  );
}
