import * as React from "react"
import {openEditEntity} from "../system/Utility";

export default function EntitiesEditLink(props: { entityId: number }) {
  return (
    <>
      <a
        className="tw-cursor-pointer"
        onClick={() => openEditEntity(props.entityId)}
      >Редактировать</a>
    </>
  )
}