import * as React from 'react';
import openEditEntity from '../system/Utility';

export default function EntitiesEditLink(props: { entityId: number }) {
  return (
    <button
      type="button"
      className="tw-cursor-pointer"
      onClick={() => openEditEntity(props.entityId)}
    >
      Редактировать
    </button>
  );
}
