package user

data: user_profile: {
	description: "ユーザープロフィール情報"
	columns: {
		profile_id: {pk: 1, type: "string", size: 36, description: "プロフィールID"}
		user_id: {type: "string", size: 36, description: "ユーザーID"}
		bio: {type: "string", is_max_size: true, description: "自己紹介"}
		website: {type: "string", size: 255, description: "ウェブサイトURL"}
	}
}

i_relations: user_profile_relations: [
	{
		source: {table_name: data.user.name, column: data.user.columns.user_id.name}
		target: {table_name: data.user_profile.name, column: data.user_profile.columns.user_id.name, zero: false}
	},
]
