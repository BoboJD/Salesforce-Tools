public interface IUsersSelector extends fflib_ISObjectSelector{
	User selectById(Id userId);
	List<User> selectByIds(Set<Id> userIds);
}