import * as React from 'react';
import MentionsCore from '../Mentions/MentionsCore';
import { useCallback } from 'react';
import axios from '../system/Axios';
import { MentionResponse } from '../system/TypeScript';

export default function ListingMentions(
  {
    listing_id,
  }: {
    listing_id: number,
  },
) {
  const fetchFunction = useCallback(({
    searchString, sort, listingId, pageParam,
  }: { entityIds?: any[], searchString?: string, sort?: string, pageParam?: number, listingId?: number }) => axios.get<MentionResponse>(`/api/listings/${listingId}/mentions`, {
    page: pageParam,
    q: searchString,
    sort,
  }), []);

  return (
    <MentionsCore listingId={listing_id} fetchFunction={fetchFunction} />
  );
}
